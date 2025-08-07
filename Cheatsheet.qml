import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland

Scope { // Scope
    id: root

    Loader {
        id: cheatsheetLoader
        active: false
        
        sourceComponent: PanelWindow { // Window
            id: cheatsheetRoot
            visible: cheatsheetLoader.active

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            function hide() {
                cheatsheetLoader.active = false
            }
            exclusiveZone: 0
            implicitWidth: cheatsheetBackground.width + Appearance.sizes.elevationMargin * 2
            implicitHeight: cheatsheetBackground.height + Appearance.sizes.elevationMargin * 2
            WlrLayershell.namespace: "quickshell:cheatsheet"
            // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: "transparent"

            mask: Region {
                item: cheatsheetBackground
            }

            HyprlandFocusGrab { // Click outside to close
                id: grab
                windows: [ cheatsheetRoot ]
                active: cheatsheetRoot.visible
                onCleared: () => {
                    if (!active) cheatsheetRoot.hide()
                }
            }

            Rectangle {
                id: cheatsheetBackground
                anchors.centerIn: parent
                color: Appearance.colors.colLayer0
                radius: Appearance.rounding.windowRounding
                property real padding: 30
                implicitWidth: cheatsheetColumnLayout.implicitWidth + padding * 2
                implicitHeight: cheatsheetColumnLayout.implicitHeight + padding * 2

                Keys.onPressed: (event) => { // Esc to close
                    if (event.key === Qt.Key_Escape) {
                        cheatsheetRoot.hide()
                    }
                }


                ColumnLayout { // Real content
                    id: cheatsheetColumnLayout
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        id: cheatsheetTitle
                        Layout.alignment: Qt.AlignHCenter
                        font.family: Appearance.font.family.title
                        font.pixelSize: Appearance.font.pixelSize.title
                        text: qsTr("Cheat sheet")
                        color: "#fff"
                    }
                    CheatsheetKeybinds {}
                }
            }

        }
    }

    IpcHandler {
        target: "c-cheatsheet"

        function toggle(): void {
            cheatsheetLoader.active = !cheatsheetLoader.active
        }

        function close(): void {
            cheatsheetLoader.active = false
        }

        function open(): void {
            cheatsheetLoader.active = true
        }
    }

    GlobalShortcut {
        name: "c-cheatsheetToggle"
        description: qsTr("Toggles cheatsheet on press")

        onPressed: {
            cheatsheetLoader.active = !cheatsheetLoader.active;
        }
    }

    GlobalShortcut {
        name: "c-cheatsheetOpen"
        description: qsTr("Opens cheatsheet on press")

        onPressed: {
            cheatsheetLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "c-cheatsheetClose"
        description: qsTr("Closes cheatsheet on press")

        onPressed: {
            cheatsheetLoader.active = false;
        }
    }

}
