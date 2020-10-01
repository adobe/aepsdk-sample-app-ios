# Variables
PROJECT_NAME = AEPCore
TARGET_NAME_AEPSERVICES = AEPServices
TARGET_NAME_AEPEVENTHUB = AEPEventHub
TARGET_NAME_AEPIDENTITY = AEPIdentity
TARGET_NAME_AEPLIFECYCLE = AEPLifecycle
TARGET_NAME_AEPCORE = AEPCore

# targets
unit-test:
	@echo "######################################################################"
	@echo "### Unit Testing iOS"
	@echo "######################################################################"
	xcodebuild test -workspace $(PROJECT_NAME).xcworkspace -scheme $(PROJECT_NAME) -destination 'platform=iOS Simulator,name=iPhone 8,OS=13.0'

archive: clean
	xcodebuild archive -scheme AEP-All -archivePath "./build/ios.xcarchive" -sdk iphoneos -destination="iOS" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES -workspace  AEPCore.xcworkspace  
	xcodebuild archive -scheme AEP-All -archivePath "./build/ios_simulator.xcarchive" -sdk iphonesimulator -destination="iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES -workspace  AEPCore.xcworkspace
	xcodebuild -create-xcframework -framework ./build/ios_simulator.xcarchive/Products/Library/Frameworks/AEPServices.framework -framework ./build/ios.xcarchive/Products/Library/Frameworks/AEPServices.framework -output ./build/AEPServices.xcframework
	xcodebuild -create-xcframework -framework ./build/ios_simulator.xcarchive/Products/Library/Frameworks/AEPEventHub.framework -framework ./build/ios.xcarchive/Products/Library/Frameworks/AEPEventHub.framework -output ./build/AEPEventHub.xcframework
	xcodebuild -create-xcframework -framework ./build/ios_simulator.xcarchive/Products/Library/Frameworks/AEPIdentity.framework -framework ./build/ios.xcarchive/Products/Library/Frameworks/AEPIdentity.framework -output ./build/AEPIdentity.xcframework
	xcodebuild -create-xcframework -framework ./build/ios_simulator.xcarchive/Products/Library/Frameworks/AEPLifecycle.framework -framework ./build/ios.xcarchive/Products/Library/Frameworks/AEPLifecycle.framework -output ./build/AEPLifecycle.xcframework
	xcodebuild -create-xcframework -framework ./build/ios_simulator.xcarchive/Products/Library/Frameworks/AEPCore.framework -framework ./build/ios.xcarchive/Products/Library/Frameworks/AEPCore.framework -output ./build/AEPCore.xcframework
	xcodebuild -create-xcframework -framework ./build/ios_simulator.xcarchive/Products/Library/Frameworks/SwiftRulesEngine.framework -framework ./build/ios.xcarchive/Products/Library/Frameworks/SwiftRulesEngine.framework -output ./build/SwiftRulesEngine.xcframework

clean:
	rm -rf ./build

