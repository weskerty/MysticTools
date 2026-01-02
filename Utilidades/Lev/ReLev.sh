A1="$HOME"
cd "$A1"||exit 1
B1="levanter"
C1="$(mktemp -d)"
if [ -d "$B1" ];then
 cd "$B1"||exit 1
 D1="$PWD"
else
 exit 1
fi
for E1 in database.db config.env config.json;do
 [ -f "$E1" ]&&cp "$E1" "$C1/"
done
cd "$A1"||exit 1
rm -rf "$B1"
git clone https://github.com/lyfe00011/levanter.git||exit 1
cd "$B1"||exit 1
for E1 in database.db config.env config.json;do
 [ -f "$C1/$E1" ]&&mv "$C1/$E1" .
done
yarn install||exit 1
pm2 start . --name levanter --attach --time
