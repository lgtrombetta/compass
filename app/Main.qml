import QtQuick 2.4
import Ubuntu.Components 1.3
import Compass 1.0
import QtSensors 5.2

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "xompass.emanuelesorce" //COMPASS ID
    width: units.gu(100)
    height: units.gu(75)

    property int kot: 0
    property int calibration: 0
    property bool use_qt_api: compass.reading != null ? compass.reading.timestamp != 0 : false

	// ------------------------------------
	// standard Qt API --------------------
	Compass {
		id: compass
		active: true

		onReadingChanged: {
			kot = - compass.reading.azimuth;
			igla.rotation = kot;
            calibration = compass.reading.calibrationLevel * 100
		}
	}

    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("Compass")
        }
		// --------------------------------
        // legacy -------------------------
        Timer {
            id: timer1
            interval: 100;
            running: !use_qt_api;
            repeat: true
            onTriggered: {
                if(!use_qt_api){
                  kot =  myType.launch()
                  myType.helloWorld = kot
                  igla.rotation = kot
               }
            }
        }
		MyType {
            id: myType
        }

        Column {
            width: parent.width
            anchors {
                centerIn:parent
                top: pageHeader.bottom
                margins: units.gu(6)
                fill: parent
                horizontalCenter: pageHeader.horizontalCenter
            }
            spacing: units.gu(5)

            Image {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                source: "graphics/compass1.png"
                Image {
                    id: igla
                    source: "graphics/igla.png"
                }
            }
            Label {
                id: label
                objectName: "label"
                width: parent.width
                wrapMode: Text.WordWrap
                text: kot != -1 ?
                    i18n.tr("Azimuth: ") + kot + i18n.tr("°"):
                    i18n.tr("No compass backend found. Check if your device has a working compass sensor.")
            }
            Label {
                visible: use_qt_api
                width: parent.width
                wrapMode: Text.WordWrap
                text: i18n.tr("Calibration: ") + calibration + "%"
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: i18n.tr("To calibrate compass, keep rotating your device on a flat surface")
            }
            Button {
                objectName: "button21"
                anchors {
                    topMargin: units.gu(2)
                }
				visible: !use_qt_api
                width: parent.width

                text: i18n.tr("Calibrate")

                onClicked: {
                    timer1.stop()
                    myType.calibrate()
                    timer1.start()
                }
            }
        }
    }
}

