#!/usr/bin/fish

#If received parameters is less than 2, print usage
if [ (count $argv) -lt "2" ]; then
  echo "\033[1;32mUsage: ./ruijie_template.sh <username> <password>\033[0m"
  echo "  Example: ./ruijie_template.sh 22122739 Passw0rd"
  exit 1
end

#Exit the script when is already online, use www.google.cn/generate_204 to check the online status
set captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
if [ "$captiveReturnCode" = "204" ]
  echo "You are already online!"
  exit 0
end

#If not online, begin Ruijie Auth

#Get Ruijie login page URL
set loginPageURL (curl -s "http://www.google.cn/generate_204" | awk -F \' '{print $2}')

#Structure loginURL
set loginURL (echo ${loginPageURL} | awk -F \? '{print $1}')
set loginURL "$loginURL/index.jsp/InterFace.do?method=login"

set service "这里填写你的service"
set queryString "这里填写你的queryString"
set queryString (string replace --all '&' '%2526' $queryString)
set queryString (string replace --all '=' '%253D' $queryString)

#Send Ruijie eportal auth request and output result
if [ -n "$loginURL" ]
  set authResult (curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "${loginPageURL}" -b "EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_SERVER_NAME=; EPORTAL_AUTO_LAND=; EPORTAL_USER_GROUP=; EPORTAL_COOKIE_OPERATORPWD=;" -d "userId=${1}&password=${2}&service=${service}&queryString=${queryString}&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "${loginURL}")
  echo $authResult
end
