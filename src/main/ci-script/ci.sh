#!/usr/bin/env bash

if [ -z "${BUILD_DEPENDENCY_CHECK}" ]; then BUILD_DEPENDENCY_CHECK="false"; fi
if [ -z "${BUILD_PUBLISH_DEPLOY_SEGREGATION}" ]; then BUILD_PUBLISH_DEPLOY_SEGREGATION="false"; fi
if [ -z "${BUILD_SITE}" ]; then BUILD_SITE="false"; fi
if [ -z "${BUILD_TEST_FAILURE_IGNORE}" ]; then BUILD_TEST_FAILURE_IGNORE="false"; fi
if [ -z "${BUILD_TEST_SKIP}" ]; then BUILD_TEST_SKIP="false"; fi

if [ -z "${OSS_BUILD_GIT_SERVICE}" ]; then OSS_BUILD_GIT_SERVICE="https://github.com"; fi
if [ -z "${OSS_BUILD_GIT_REPO_OWNER}" ]; then OSS_BUILD_GIT_REPO_OWNER="home1-oss"; fi

echo "MAVEN_SETTINGS_SECURITY_FILE: ${MAVEN_SETTINGS_SECURITY_FILE}"

echo "pwd: $(pwd)"
echo "whoami: $(whoami)"

if [ -f ~/.bashrc ]; then source ~/.bashrc; fi

COMMIT_ID="$(git rev-parse HEAD)"
CI_CACHE="${HOME}/.ci-cache/${COMMIT_ID}"
mkdir -p ${CI_CACHE}

# see: https://gitlab.com/help/ci/variables/README.md
# ${CI_BUILD_REF_NAME} show branch or tag since GitLab-CI 5.2
# ${CI_PROJECT_URL} example: "https://example.com/gitlab-org/gitlab-ce"
if [ -n "${OSS_BUILD_REF_BRANCH}" ] ; then BUILD_SCRIPT_REF="${OSS_BUILD_REF_BRANCH}"; else BUILD_SCRIPT_REF="develop"; fi
if [ -z "${OSS_BUILD_CONFIG_REF_BRANCH}" ] ; then OSS_BUILD_CONFIG_REF_BRANCH="develop"; fi
if [ -z "${GIT_SERVICE}" ]; then
    if [ -n "${CI_PROJECT_URL}" ]; then INFRASTRUCTURE="internal"; GIT_SERVICE=$(echo "${CI_PROJECT_URL}" | sed 's,/*[^/]\+/*$,,' | sed 's,/*[^/]\+/*$,,'); else INFRASTRUCTURE="local"; GIT_SERVICE="${LOCAL_GIT_SERVICE}"; fi
fi
BUILD_SCRIPT_LOC="${OSS_BUILD_GIT_SERVICE}/${OSS_BUILD_GIT_REPO_OWNER}/oss-build/raw/${BUILD_SCRIPT_REF}";
BUILD_CONFIG_LOC="${GIT_SERVICE}/${GIT_REPO_OWNER}/oss-${INFRASTRUCTURE}/raw/${OSS_BUILD_CONFIG_REF_BRANCH}"
echo "INFRASTRUCTURE: ${INFRASTRUCTURE}, BUILD_SCRIPT_LOC: ${BUILD_SCRIPT_LOC}, BUILD_CONFIG_LOC: ${BUILD_CONFIG_LOC}"

if ([ "internal" == "${INFRASTRUCTURE}" ] || [ "local" == "${INFRASTRUCTURE}" ]) ; then
    # for internal jira
    echo "eval \$(curl -H 'Cache-Control: no-cache' -H \"PRIVATE-TOKEN: \${GIT_SERVICE_TOKEN}\" -s -L ${BUILD_CONFIG_LOC}/src/main/jira/jira-${INFRASTRUCTURE}.sh)"
    eval "$(curl -H 'Cache-Control: no-cache' -H "PRIVATE-TOKEN: ${GIT_SERVICE_TOKEN}" -s -L ${BUILD_CONFIG_LOC}/src/main/jira/jira-${INFRASTRUCTURE}.sh)"
    # for internal/local docker auth,if local env has no file will download form oss-${INFRASTRUCTURE}
    if [ ! -d "${HOME}/.docker/" ]; then mkdir -p "${HOME}/.docker/"; echo "mkdir ${HOME}/.docker/ "; fi

    file_resp_code=$(curl -H 'Cache-Control: no-cache' -H "PRIVATE-TOKEN: ${GIT_SERVICE_TOKEN}" -t utf-8 -s -L -I ${BUILD_CONFIG_LOC}/src/main/docker/config.json \
        | grep "HTTP/1.1" | awk '{print $2}' )
    echo "get docker config.json http respon from ${BUILD_CONFIG_LOC}/src/main/docker/config.json,responsecode=${file_resp_code}"
    if [ "200"=="$file_resp_code" ];then
        curl -H 'Cache-Control: no-cache' -H "PRIVATE-TOKEN: ${GIT_SERVICE_TOKEN}" -t utf-8 -s -L -o ${HOME}/.docker/config.json ${BUILD_CONFIG_LOC}/src/main/docker/config.json
    fi
    # for internal/local settings-security.xml,always download form oss-${INFRASTRUCTURE}
    file_resp_code=$(curl -H 'Cache-Control: no-cache' -H "PRIVATE-TOKEN: ${GIT_SERVICE_TOKEN}" -t utf-8 -s -L -I ${BUILD_CONFIG_LOC}/src/main/maven/settings-security.xml \
        | grep "HTTP/1.1" | awk '{print $2}' )
    echo "get maven settings-security.xml http respon from ${BUILD_CONFIG_LOC}/src/main/docker/config.json,responsecode=${file_resp_code}"
    if [ "200"=="$file_resp_code" ];then
        curl -H 'Cache-Control: no-cache' -H "PRIVATE-TOKEN: ${GIT_SERVICE_TOKEN}" -t utf-8 -s -L -o ${HOME}/.m2/settings-security.xml ${BUILD_CONFIG_LOC}/src/main/maven/settings-security.xml
    fi
fi

if [ -n "${DOCKERHUB_PASS}" ] && [ -n "${DOCKERHUB_USER}" ]; then
    docker login -p="${DOCKERHUB_PASS}" -u="${DOCKERHUB_USER}" https://registry-1.docker.io/v1/
    docker login -p="${DOCKERHUB_PASS}" -u="${DOCKERHUB_USER}" https://registry-1.docker.io/v2/
fi

echo "eval \$(curl -H 'Cache-Control: no-cache' -s -L ${BUILD_SCRIPT_LOC}/src/main/ci-script/lib_java.sh)"
eval "$(curl -H 'Cache-Control: no-cache' -s -L ${BUILD_SCRIPT_LOC}/src/main/ci-script/lib_java.sh)"
echo "eval \$(curl -H 'Cache-Control: no-cache' -s -L ${BUILD_SCRIPT_LOC}/src/main/ci-script/lib_maven.sh)"
eval "$(curl -H 'Cache-Control: no-cache' -s -L ${BUILD_SCRIPT_LOC}/src/main/ci-script/lib_maven.sh)"
echo "eval \$(curl -H 'Cache-Control: no-cache' -s -L ${BUILD_SCRIPT_LOC}/src/main/ci-script/lib_gradle.sh)"
eval "$(curl -H 'Cache-Control: no-cache' -s -L ${BUILD_SCRIPT_LOC}/src/main/ci-script/lib_gradle.sh)"

analysis() {
    echo "analysis @ $(pwd)";
    if [ -f pom.xml ]; then maven_analysis; fi
}

test_and_build() {
    echo "test_and_build @ $(pwd)";
    if [ -f pom.xml ]; then maven_test_and_build; fi
    if [ -f build.gradle ]; then gradle_test_and_build; fi
}

publish_snapshot() {
    echo "publish_snapshot @ $(pwd)";
    if [ -z "${BUILD_PUBLISH_CHANNEL}" ] ; then BUILD_PUBLISH_CHANNEL="snapshot"; fi
    if [ -f pom.xml ]; then maven_publish_snapshot; fi
    if [ -f build.gradle ]; then gradle_publish_snapshot; fi
}

publish_release() {
    echo "publish_release @ $(pwd)";
    if [ -z "${BUILD_PUBLISH_CHANNEL}" ] ; then BUILD_PUBLISH_CHANNEL="release"; fi
    if [ -f pom.xml ]; then maven_publish_release; fi
    if [ -f build.gradle ]; then gradle_publish_release; fi
}

publish_maven_site(){
    echo "publish_maven_site @ $(pwd)";
    if [ -f pom.xml ]; then maven_publish_maven_site; fi
}

publish_release_tag() {
    echo "publish_release_tag @ $(pwd)";
}
