#!/bin/sh

if [ "${#}" -lt "2" ]; then
  echo "Usage: ./ruijie.sh username password"
  echo "Example: ./ruijie.sh 2017123412345 123456"
  exit 1
fi

captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
if [ "${captiveReturnCode}" = "204" ]; then
  echo "你已经成功认证了!"
  exit 0
fi

loginPageURL=`curl -s "http://www.google.cn/generate_204" | awk -F \' '{print $2}'`

loginURL=`echo ${loginPageURL} | awk -F \? '{print $1}'`
loginURL="${loginURL/index.jsp/InterFace.do?method=login}"

#service的参数默认设置为校园网了，如有需要自行修改
#校园网：internet
#中国移动：%25E7%25A7%25BB%25E5%258A%25A8%25E5%2587%25BA%25E5%258F%25A3
#中国电信：%25E7%2594%25B5%25E4%25BF%25A1%25E5%2587%25BA%25E5%258F%25A3

service="%25E8%25AE%25BF%25E9%2597%25AE%25E4%25BA%2592%25E8%2581%2594%25E7%25BD%2591"
queryString="wlanuserip=ec4b71e71d7b29f68bc536af418b0e8f&wlanacname=e23b498ec1c231d6d4930c38297b5c65&ssid=&nasip=c96c8874387c8f0522c256eaae64fe4e&snmpagentip=&mac=fde83571d493f519face9d6b4ba9e853&t=wireless-v2&url=efc577a38c20aefb2f847d36c0a75a3c621adaebcd3ac8563259ee064598233c6b5e5cd2a0195a0b&apmac=&nasid=e23b498ec1c231d6d4930c38297b5c65&vid=35224416b8dc3408&port=26877a4b43e24d03&nasportid=abe3785fa3ed4ac0e63a749531e94005f6e7211cd75fd1949327caeb403a613715a5069ebda83fff"
queryString="${queryString//&/%2526}"
queryString="${queryString//=/%253D}"


if [ -n "${loginURL}" ]; then
  authResult=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "${loginPageURL}" -b "EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_SERVER_NAME=; EPORTAL_AUTO_LAND=; EPORTAL_USER_GROUP=; EPORTAL_COOKIE_OPERATORPWD=;" -d "userId=${1}&password=${2}&service=${service}&queryString=${queryString}&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "${loginURL}"`
  echo $authResult
fi