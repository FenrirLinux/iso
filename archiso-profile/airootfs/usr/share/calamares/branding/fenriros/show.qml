/* FenrirOS Calamares Installer Slideshow
 * Displayed while files are being copied to disk
 */

import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function nextSlide() {
        presentation.goToNextSlide()
    }

    Timer {
        id: timer
        interval: 5000
        repeat: true
        running: true
        onTriggered: presentation.nextSlide()
    }

    // --- Slide 1: Welcome ---
    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0d0d0d"

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -60
                text: "FENRIROS"
                font.family: "Rajdhani"
                font.pointSize: 48
                font.bold: true
                color: "#e8e0d0"
                letterSpacing: 8
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 10
                text: "U N C H A I N E D"
                font.family: "Rajdhani"
                font.pointSize: 16
                color: "#c0392b"
                letterSpacing: 6
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 60
                text: "Gaming Linux, free from systemd."
                font.family: "Rajdhani"
                font.pointSize: 12
                color: "#a09888"
            }
        }
    }

    // --- Slide 2: OpenRC ---
    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0d0d0d"

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                text: "OpenRC Init System"
                font.family: "Rajdhani"
                font.pointSize: 32
                font.bold: true
                color: "#e8e0d0"
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 20
                text: "Fast. Transparent. Unchained.\nOpenRC boots your system without systemd complexity.\nParallel startup. Clean service management."
                font.family: "Rajdhani"
                font.pointSize: 13
                color: "#a09888"
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 1.6
            }
        }
    }

    // --- Slide 3: Gaming Stack ---
    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0d0d0d"

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                text: "Built for Gaming"
                font.family: "Rajdhani"
                font.pointSize: 32
                font.bold: true
                color: "#e8e0d0"
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 20
                text: "Steam · Proton · Lutris · MangoHud · GameMode\nCachyOS Kernel · SCX LAVD Scheduler\nFull Linux gaming stack, ready out of the box."
                font.family: "Rajdhani"
                font.pointSize: 13
                color: "#a09888"
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 1.6
            }
        }
    }

    // --- Slide 4: Performance ---
    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0d0d0d"

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                text: "CachyOS Performance Kernel"
                font.family: "Rajdhani"
                font.pointSize: 32
                font.bold: true
                color: "#e8e0d0"
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 20
                text: "linux-cachyos with BORE + LAVD schedulers.\nLowest input latency. Best frame timing.\nSCX userspace schedulers for real-time gaming."
                font.family: "Rajdhani"
                font.pointSize: 13
                color: "#a09888"
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 1.6
            }
        }
    }

    // --- Slide 5: Welcome to the pack ---
    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0d0d0d"

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                text: "Welcome to the Pack"
                font.family: "Rajdhani"
                font.pointSize: 32
                font.bold: true
                color: "#c0392b"
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 20
                text: "FenrirOS is almost ready.\nYour system is being configured for battle.\nThe wolf runs free."
                font.family: "Rajdhani"
                font.pointSize: 13
                color: "#a09888"
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 1.6
            }
        }
    }
}
