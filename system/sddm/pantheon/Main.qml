// Pantheon SDDM theme — minimal, Nord-tinted, Qt6.
// Tunables live in theme.conf (background, dim, blur, accent, font).
import QtQuick
import QtQuick.Effects
import QtQuick.Window
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#2e3440"

    // ---- config ----
    readonly property real dim:      config.dim    !== undefined ? Number(config.dim)  : 0.45
    readonly property real blurAmt:  config.blur   !== undefined ? Number(config.blur) : 0.0
    readonly property color accent:  config.accent || "#88c0d0"
    readonly property color fg:      "#eceff4"
    readonly property color danger:  "#bf616a"
    readonly property string fontFamily: config.font || "JetBrainsMono Nerd Font"
    // Frosted card behind the login form
    readonly property bool card:         config.card === "true"
    readonly property real cardOpacity:  config.cardOpacity !== undefined ? Number(config.cardOpacity) : 0.35
    readonly property color cardTint:    config.cardTint || "#1c1f29"
    readonly property real cardBorder:   config.cardBorder !== undefined ? Number(config.cardBorder) : 0.10
    readonly property real cardBlur:     config.cardBlur    !== undefined ? Number(config.cardBlur)    : 0.8
    // Soft drop shadow under the clock/date
    readonly property bool textShadow:   config.textShadow === "true"
    // SDDM draws one window per monitor. formScreen picks which get the login form:
    //   largest (default) = biggest monitor, all = every monitor, primary = SDDM's choice
    readonly property string formScreen: config.formScreen || "largest"
    readonly property bool isPrimary: {
        if (formScreen === "all") return true
        if (formScreen === "primary") return typeof primaryScreen === "undefined" ? true : primaryScreen
        var screens = Qt.application.screens, best = null
        for (var i = 0; i < screens.length; i++)
            if (!best || screens[i].width * screens[i].height > best.width * best.height) best = screens[i]
        // Compare by size, not name: this window is sized to its monitor.
        return !best || (root.width === best.width && root.height === best.height)
    }
    // Preview helper: screenshot=<path> saves <path>-<width>.png after load.
    Timer {
        running: config.screenshot !== undefined && config.screenshot !== ""
        interval: 1500
        onTriggered: root.grabToImage(function (r) { r.saveToFile(config.screenshot + "-" + root.width + ".png") })
    }
    // Grab keyboard focus on the screen that shows the form.
    function grabFocus() {
        if (!isPrimary) return
        password.forceActiveFocus()
        if (root.Window.window) root.Window.window.requestActivate()
    }
    Component.onCompleted: Qt.callLater(grabFocus)

    // ---- state ----
    property int userIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property string message: ""

    // Repeaters always instantiate every delegate (a hidden ListView doesn't),
    // so we can read model roles by index.
    Item {
        visible: false
        Repeater { id: users;    model: userModel;    Item { property string uName: model.name; property string uReal: model.realName } }
        Repeater { id: sessions; model: sessionModel; Item { property string sName: model.name } }
    }
    readonly property var userItem: users.count > root.userIndex ? users.itemAt(root.userIndex) : null
    readonly property string userName: userItem ? userItem.uName : ""
    readonly property var sessionItem: sessions.count > root.sessionIndex ? sessions.itemAt(root.sessionIndex) : null
    readonly property string sessionName: sessionItem ? sessionItem.sName : ""

    function doLogin() {
        if (password.text.length === 0 || username.text.length === 0) return
        root.message = ""
        sddm.login(username.text, password.text, root.sessionIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            password.text = ""
            root.message = "Wrong password"
            shake.restart()
            password.forceActiveFocus()
        }
    }

    // ---- background ----
    Item {
    id: scene
    anchors.fill: parent
    Image {
        id: bg
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background)
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        visible: root.blurAmt <= 0
    }
    MultiEffect {
        anchors.fill: bg
        source: bg
        visible: root.blurAmt > 0
        blurEnabled: true
        blur: root.blurAmt
        blurMax: 64
        autoPaddingEnabled: false
    }
    Rectangle { anchors.fill: parent; color: "#000000"; opacity: root.dim }
    // soft vignette toward the bottom so the controls stay legible
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.55; color: "transparent" }
            GradientStop { position: 1.0;  color: "#a0000000" }
        }
    }
    } // scene

    // ---- clock ----
    Column {
        id: clockCol
        layer.enabled: root.textShadow
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#000000"
            shadowOpacity: 0.9
            shadowBlur: 1.0
            blurMax: 48
            shadowScale: 1.04
            shadowVerticalOffset: 3
            shadowHorizontalOffset: 0
        }
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.isPrimary ? parent.height * 0.16 : (parent.height - height) / 2
        spacing: 4

        Text {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.fg
            font { family: root.fontFamily; pixelSize: 120; weight: Font.Light }
            text: Qt.formatTime(new Date(), "HH:mm")
        }
        Text {
            id: date
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.fg; opacity: 0.75
            font { family: root.fontFamily; pixelSize: 20 }
            text: Qt.formatDate(new Date(), "dddd, d MMMM")
        }
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                clock.text = Qt.formatTime(new Date(), "HH:mm")
                date.text = Qt.formatDate(new Date(), "dddd, d MMMM")
            }
        }
    }

    // ---- frosted card behind the form ----
    Item {
        id: cardBox
        visible: root.isPrimary && root.card
        anchors.centerIn: form
        width: form.width + 80
        height: form.height + 64

        ShaderEffectSource {
            id: cardSrc
            sourceItem: scene
            sourceRect: Qt.rect(cardBox.x, cardBox.y, cardBox.width, cardBox.height)
            anchors.fill: parent
            visible: false
        }
        Rectangle { id: cardMask; anchors.fill: parent; radius: 26; visible: false; layer.enabled: true }
        MultiEffect {
            anchors.fill: parent
            source: cardSrc
            blurEnabled: root.cardBlur > 0
            blur: root.cardBlur
            blurMax: 48
            autoPaddingEnabled: false
            maskEnabled: true
            maskSource: cardMask
        }
        Rectangle {   // tint
            anchors.fill: parent
            radius: 26
            color: root.cardTint
            opacity: root.cardOpacity
        }
        Rectangle {   // hairline border
            anchors.fill: parent
            radius: 26
            color: "transparent"
            border { width: 1; color: Qt.rgba(1, 1, 1, root.cardBorder) }
        }
    }

    // ---- login form ----
    Column {
        id: form
        visible: root.isPrimary
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: shakeOffset
        anchors.top: clockCol.bottom
        anchors.topMargin: parent.height * 0.12
        spacing: 12
        property real shakeOffset: 0

        SequentialAnimation {
            id: shake
            loops: 1
            NumberAnimation { target: form; property: "shakeOffset"; to: -14; duration: 50 }
            NumberAnimation { target: form; property: "shakeOffset"; to: 14;  duration: 70 }
            NumberAnimation { target: form; property: "shakeOffset"; to: -8;  duration: 60 }
            NumberAnimation { target: form; property: "shakeOffset"; to: 0;   duration: 50 }
        }

        // username pill: prefilled with the last user, editable to type another
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320; height: 46; radius: 23
            color: Qt.rgba(1, 1, 1, username.activeFocus ? 0.14 : 0.10)
            border { width: 1; color: username.activeFocus ? root.accent : Qt.rgba(1, 1, 1, 0.18) }
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }

            Text {
                id: userGlyph
                anchors { left: parent.left; leftMargin: 20; verticalCenter: parent.verticalCenter }
                text: "\uf007"; color: root.fg; opacity: 0.7
                font { family: root.fontFamily; pixelSize: 15 }
            }
            TextInput {
                id: username
                anchors { left: userGlyph.right; right: userSwitch.left; verticalCenter: parent.verticalCenter; leftMargin: 14; rightMargin: 8 }
                text: root.userName
                color: root.fg
                font { family: root.fontFamily; pixelSize: 16; weight: Font.Medium }
                clip: true
                selectByMouse: true
                selectionColor: root.accent
                KeyNavigation.tab: password
                Keys.onReturnPressed: password.forceActiveFocus()
                Keys.onEnterPressed: password.forceActiveFocus()
                onTextChanged: root.message = ""
            }
            Text {
                anchors { left: username.left; verticalCenter: parent.verticalCenter }
                visible: username.text.length === 0
                text: "Username"
                color: root.fg; opacity: 0.45
                font { family: root.fontFamily; pixelSize: 15 }
            }
            // cycle through known users (only when there's more than one)
            IconButton {
                id: userSwitch
                anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
                visible: users.count > 1
                width: visible ? implicitWidth : 0
                glyph: "\uf0dc"; size: 14
                onClicked: {
                    root.userIndex = (root.userIndex + 1) % users.count
                    username.text = root.userName
                    password.text = ""
                    password.forceActiveFocus()
                }
            }
        }

        // password pill
        Rectangle {
            id: pill
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320; height: 46; radius: 23
            color: Qt.rgba(1, 1, 1, password.activeFocus ? 0.14 : 0.10)
            border { width: 1; color: password.activeFocus ? root.accent : Qt.rgba(1, 1, 1, 0.18) }
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }

            TextInput {
                id: password
                anchors { left: parent.left; right: submit.left; verticalCenter: parent.verticalCenter; leftMargin: 22; rightMargin: 8 }
                color: root.fg
                font { family: root.fontFamily; pixelSize: 16; letterSpacing: 3 }
                echoMode: TextInput.Password
                passwordCharacter: "•"
                passwordMaskDelay: 0
                clip: true
                selectByMouse: true
                selectionColor: root.accent
                focus: root.isPrimary
                onTextChanged: if (text.length) root.message = ""
                KeyNavigation.backtab: username
                Keys.onReturnPressed: root.doLogin()
                Keys.onEnterPressed: root.doLogin()
            }
            Text {
                anchors { left: password.left; verticalCenter: parent.verticalCenter }
                visible: password.text.length === 0
                text: "Password"
                color: root.fg; opacity: 0.45
                font { family: root.fontFamily; pixelSize: 15 }
            }
            IconButton {
                id: submit
                anchors { right: parent.right; rightMargin: 14; verticalCenter: parent.verticalCenter }
                glyph: ""; size: 16
                enabled: password.text.length > 0
                opacity: enabled ? 1 : 0.35
                onClicked: root.doLogin()
            }
        }

        // status line: error or caps lock
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 20
            text: root.message.length ? root.message
                  : (keyboard.capsLock ? "  Caps Lock is on" : "")
            color: root.message.length ? root.danger : "#ebcb8b"
            font { family: root.fontFamily; pixelSize: 14 }
        }
    }

    // ---- bottom bar ----
    Item {
        visible: root.isPrimary
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 32 }
        height: 32

        // session switcher (click to cycle)
        Row {
            id: sessionRow
            anchors { left: parent.left; verticalCenter: parent.verticalCenter }
            spacing: 10
            opacity: sessionMouse.containsMouse ? 1 : 0.7
            Behavior on opacity { NumberAnimation { duration: 120 } }
            Text { text: ""; color: root.fg; font { family: root.fontFamily; pixelSize: 16 } }
            Text { text: root.sessionName; color: root.fg; font { family: root.fontFamily; pixelSize: 15 } }
            Text {
                visible: sessions.count > 1
                text: ""; color: root.fg; opacity: 0.6
                font { family: root.fontFamily; pixelSize: 12 }
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        MouseArea {
            id: sessionMouse
            anchors.fill: sessionRow; anchors.margins: -6
            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
            onClicked: root.sessionIndex = (root.sessionIndex + 1) % sessions.count
        }

        // power
        Row {
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            spacing: 22
            IconButton { glyph: ""; size: 18; visible: sddm.canSuspend;  onClicked: sddm.suspend() }
            IconButton { glyph: ""; size: 18; visible: sddm.canReboot;   onClicked: sddm.reboot() }
            IconButton { glyph: ""; size: 18; visible: sddm.canPowerOff; onClicked: sddm.powerOff() }
        }
    }

    // ---- small reusable glyph button ----
    component IconButton: Text {
        id: btn
        property string glyph
        property int size: 16
        signal clicked()
        text: glyph
        color: area.containsMouse ? root.accent : root.fg
        opacity: area.containsMouse ? 1 : 0.75
        font { family: root.fontFamily; pixelSize: size }
        Behavior on color { ColorAnimation { duration: 120 } }
        MouseArea {
            id: area
            anchors.fill: parent; anchors.margins: -6
            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
            enabled: btn.enabled
            onClicked: btn.clicked()
        }
    }
}
