#!/bin/bash

#If received parameters is less than 2, print usage
if [ "${#}" -lt "2" ]; then
  echo "\033[1;32mUsage: ./ruijie_template.sh <username> <password>\033[0m"
  echo "  Example: ./ruijie_template.sh 22122739 Passw0rd"
  exit 1
fi

#Exit the script when is already online, use www.google.cn/generate_204 to check the online status
captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
if [ "${captiveReturnCode}" = "204" ]; then
  echo "You are already online!"
  exit 0
fi

#If not online, begin Ruijie Auth

#Get Ruijie login page URL
loginPageURL=`curl -s "http://www.google.cn/generate_204" | awk -F \' '{print $2}'`

#Structure loginURL
loginURL=`echo ${loginPageURL} | awk -F \? '{print $1}'`
loginURL="${loginURL/index.jsp/InterFace.do?method=login}"

# 脚本默认的服务设置是校园网，即'service="shu"' | 中国电信 | 中国联通 | 中国移动
# services=[{"aceNotShow":"false","domainName":"false","operatorDefault":"","serviceDefault":"true","serviceName":"shu","serviceShowName":"校园网"}
# 访问互联网=%25E8%25AE%25BF%25E9%2597%25AE%25E4%25BA%2592%25E8%2581%2594%25E7%25BD%2591
service="%25E8%25AE%25BF%25E9%2597%25AE%25E4%25BA%2592%25E8%2581%2594%25E7%25BD%2591"
queryString="wlanuserip=339e0cb17502fed0190ed2d0cdc00a01&wlanacname=e23b498ec1c231d6d4930c38297b5c65&ssid=&nasip=c96c8874387c8f0522c256eaae64fe4e&snmpagentip=&mac=a98d895290d1a648e93d8094f890b8fa&t=wireless-v2&url=c52ab086a99dc365c613e763da5ad158f499587df9e647d0&apmac=&nasid=e23b498ec1c231d6d4930c38297b5c65&vid=35224416b8dc3408&port=26877a4b43e24d03&nasportid=abe3785fa3ed4ac0e63a749531e94005f6e7211cd75fd1949327caeb403a613715a5069ebda83fff"
queryString="${queryString//&/%2526}"
queryString="${queryString//=/%253D}"

#Send Ruijie eportal auth request and output result
if [ -n "${loginURL}" ]; then
  authResult=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "${loginPageURL}" -b "EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_SERVER_NAME=; EPORTAL_AUTO_LAND=; EPORTAL_USER_GROUP=; EPORTAL_COOKIE_OPERATORPWD=;" -d "userId=${1}&password=${2}&service=${service}&queryString=${queryString}&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "${loginURL}"`
  echo $authResult
fi
