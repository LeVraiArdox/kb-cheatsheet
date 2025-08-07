import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Hyprland

Item {
    id: root
    readonly property var keybinds: ({
        children: [
            {
                
                children: [
                    {
                        name: "Connectivity",
                        keybinds: [
                            {
                                mods: ["Fn"],
                                key: "1",
                                comment: "Hold about 3s to enable pairing"
                            },
                        ]
                    }
                ]
            },
            {
                children: [
                    {
                        name: "RGB",
                        keybinds: [
                            {
                                mods: ["Fn"],
                                key: "/|",
                                comment: "Switch between 16 light effects"
                            },
                            {
                                mods: ["Fn"],
                                key: "TAB",
                                comment: "Switch between light colors"
                            },
                            {
                                mods: ["Fn"],
                                key: "↑↓",
                                comment: "Adjust the backlight brightness"
                            },
                            {
                                mods: ["Fn"],
                                key: "←→",
                                comment: "Adjust Animation speed"
                            },
                            {
                                mods: ["Fn"],
                                key: "Right shift",
                                comment: "Switch RGB ambiant bar mode"
                            },
                            {
                                mods: ["Fn"],
                                key: "Right alt",
                                comment: "Adjust the brightness of the light bar"
                            },
                            {
                                mods: ["Fn"],
                                key: "B",
                                comment: "Switch RGB ambiant bar mode to bar/battery"
                            },
                        ],
                    }
                ]
            },
            {
                children: [
                    {
                        name: "Media",
                        keybinds: [
                            {
                                mods: ["Fn"],
                                key: "F8",
                                comment: "Play/Pause"
                            },
                            {
                                mods: ["Fn"],
                                key: "F7",
                                comment: "Previous track"
                            },
                            {
                                mods: ["Fn"],
                                key: "F9",
                                comment: "Next track"
                            },
                            {
                                mods: ["Fn"],
                                key: "F10",
                                comment: "Mute"
                            },
                            {
                                mods: ["Fn"],
                                key: "F11",
                                comment: "Volume +"
                            },
                            {
                                mods: ["Fn"],
                                key: "F12",
                                comment: "Volume -"
                            }
                        ]
                    }
                ]
            },
        ]
    })

    property real spacing: 16
    property real titleSpacing: 8
    width: 800
    height: 600

    property var keyBlacklist: ["Super_L"]
    property var keySubstitutions: ({
        "Super": "󰖳",
        // "Super": "⌘", // Just for you, Grace
        "mouse_up": "Scroll ↓",
        "mouse_down": "Scroll ↑",
        "mouse:272": "LMB",
        "mouse:273": "RMB",
        "mouse:275": "MouseBack",
        "Slash": "/",
        "Hash": "#",
        "Return": "Enter",
    })

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: root.width
        contentHeight: layout.implicitHeight
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        clip: true

        ColumnLayout {
            id: layout
            width: root.width
            spacing: root.spacing

            Repeater {
                model: keybinds.children

                delegate: ColumnLayout {
                    spacing: root.titleSpacing
                    required property var modelData
                    width: parent.width

                    Text {
                        text: modelData.name
                        font.pixelSize: Appearance.font.pixelSize.huge
                        font.family: Appearance.font.family.title
                        color: "#fff"
                        wrapMode: Text.Wrap
                    }

                    Repeater {
                        model: modelData.children

                        delegate: ColumnLayout {
                            spacing: root.titleSpacing
                            required property var modelData
                            width: parent.width

                            Text {
                                text: modelData.name
                                font.pixelSize: Appearance.font.pixelSize.large
                                font.family: Appearance.font.family.title
                                color: "#fff"
                                wrapMode: Text.Wrap
                            }

                            Repeater {
                                model: modelData.keybinds

                                delegate: RowLayout {
                                    spacing: 10
                                    width: parent.width

                                    // Key sequence column, fixed width for alignment
                                    Item {
                                        Layout.preferredWidth: 250
                                        Layout.preferredHeight: 25
                                        Layout.alignment: Qt.AlignLeft

                                        RowLayout {
                                            id: keyRow
                                            spacing: 4
                                            anchors.verticalCenter: parent.verticalCenter

                                            Repeater {
                                                model: modelData.mods
                                                delegate: KeyboardKey {
                                                    required property var modelData
                                                    key: keySubstitutions[modelData] || modelData
                                                }
                                            }

                                            Text {
                                                visible: !keyBlacklist.includes(modelData.key) && modelData.mods.length > 0
                                                text: "+"
                                                color: "#fff"
                                            }

                                            KeyboardKey {
                                                visible: !keyBlacklist.includes(modelData.key)
                                                key: keySubstitutions[modelData.key] || modelData.key
                                            }
                                        }
                                    }

                                    // Description, fills remaining space
                                    Text {
                                        text: modelData.comment
                                        color: "#fff"
                                        font.pixelSize: Appearance.font.pixelSize.smaller
                                        wrapMode: Text.Wrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}