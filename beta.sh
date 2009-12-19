VERSION=`python -c 'import plistlib;print plistlib.readPlist("MobilBlogg-Info.plist")["CFBundleVersion"]'`
echo "Doing MobilBlogg pkg for version $VERSION"
xcodebuild -configuration "Release beta" -sdk iphoneos3.0
rm -rf MobilBlogg-$VERSION
mkdir MobilBlogg-$VERSION
cp -r build/Release\ beta-iphoneos/MobilBlogg.app MobilBlogg-$VERSION
cp MobilBloggNU_BETA.mobileprovision MobilBlogg-$VERSION
zip -rq releases/MobilBlogg-$VERSION.zip MobilBlogg-$VERSION
rm -rf MobilBlogg-$VERSION
