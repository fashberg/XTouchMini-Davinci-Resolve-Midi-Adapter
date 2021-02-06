#include AutoHotkey-Midi/Midi.ahk
;#include AutoHotkey-Midi/MidiOut.ahk
;#include AutoHotkey-Midi/Midiout2.ahk

 
midi := new Midi()
midi.OpenMidiIn( 0 )
h:=midi.OpenMidiOut( 1 )

; standard mode
midi.MidiOut(h, "CC", 1, 127, 0)

; Layer A
midi.MidiOut(h, "PC", 1, 0, 0)
Loop 2 { 
    int:=0
    Loop 16 { 
        ; button on
        midi.MidiOut(h, "N1", 1, int, 1)
        int++
        sleep 20
    }
    int:=0
    Loop 16 { 
        ; button off
        midi.MidiOut(h, "N1", 1, int, 0)
        int++
        sleep 20
    }
    ; Layer B
    midi.MidiOut(h, "PC", 1, 1, 0)
}
; Layer A
midi.MidiOut(h, "PC", 1, 0, 0)

Gosub, ProcessSound
;ProcessSound,


#Persistent
oldSound:=0
SetTimer, ProcessSound, 1800, -1000

WheelLast1:=0
WheelLast2:=0
WheelLast3:=0
WheelLast4:=0
WheelLast5:=0
WheelLast6:=0
WheelLast7:=0


Return

ProcessSound:
    ;; get current master volume and set wheel 8
    SoundGet, master_volume
    snd := master_volume/100*127
    if (snd!=oldSound){
        OutputDebug, Sound Vol: %master_volume% / %snd%`r`n
        midi.MidiOut(h, "CC", 11, 8, snd)
        oldSound:=snd
    }
Return



MidiNoteOnA4:
    MsgBox You played note A4!
    Return

MidiControlChange1:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n

    if (ccValue>WheelLast1 or ccValue==127){
        Send {Right}
    } else if (ccValue<WheelLast1 or ccValue==0){
        Send {Left}
    }
    WheelLast1:=ccValue
    Return

MidiControlChange2:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n

    if (ccValue>WheelLast2 or ccValue==127){
        Send {Shift down}{right}{Shift up}
    } else if (ccValue<WheelLast2 or ccValue==0){
        Send {Shift down}{left}{Shift up}
    }
    WheelLast2:=ccValue
    Return

MidiControlChange3:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n
    if (ccValue>WheelLast3 or ccValue==127){
        Send {Down}
    } else if (ccValue<WheelLast3 or ccValue==0){
        Send {Up}
    }
    WheelLast3:=ccValue
    Return

MidiControlChange4:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n
    if (ccValue>WheelLast4 or ccValue==127){
        ;Send {NumpadRight}
        Send {Numpad6}
    } else if (ccValue<WheelLast4 or ccValue==0){
        ;Send {NumpadLeft}
        Send {Numpad4}
    }
    WheelLast4:=ccValue
    Return

MidiControlChange5:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n
    if (ccValue>WheelLast5 or ccValue==127){
        Send {.}
    } else if (ccValue<WheelLast4 or ccValue==0){
        Send {,}
    }
    WheelLast5:=ccValue
    Return

MidiControlChange6:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n
    if (ccValue>WheelLast6 or ccValue==127){
        Send {Ctrl down}{=}{Ctrl up}
    } else if (ccValue<WheelLast6 or ccValue==0){
        Send {Ctrl down}{-}{Ctrl up}
    }
    WheelLast6:=ccValue
    Return

MidiControlChange7:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC1 %ccValue%`r`n
    if (ccValue>WheelLast7 or ccValue==127){
        Send {Ctrl down}{=}{Ctrl up}
    } else if (ccValue<WheelLast7 or ccValue==0){
        Send {Ctrl down}{-}{Ctrl up}
    }
    WheelLast7:=ccValue
    Return

MidiControlChange8:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC8 %ccValue%`r`n
    SoundSet ccValue/127 * 100
    Return

repeatJ:
    Send {j down}
    if (repeatJFirst){
        repeatJFirst:=false
        SetTimer, , 10
    }
    Return


MidiNoteOn8:
    Send {a}
    midi.MidiOut(h, "N1", 1, 0, 1)
    midi.MidiOut(h, "N0", 1, 1, 0)
    Return

MidiNoteOff8:
    midi.MidiOut(h, "N1", 1, 0, 1)
    Return

MidiNoteOn9:
    Send {t}
    midi.MidiOut(h, "N0", 1, 0, 0)
    Return

MidiNoteOff9:
    midi.MidiOut(h, "N1", 1, 1, 1)
    Return

MidiNoteOn10:
    Send {w}
    if (!oldW){
        midi.MidiOut(h, "N0", 1, 2, 0)
    }
    oldW:=!oldW
    Return

MidiNoteOff10:
    if (oldW){
        midi.MidiOut(h, "N1", 1, 2, 1)
    }
    Return

MidiNoteOn21:
    repeatJFirst:=true
    Send {j down}
    SetTimer, repeatJ, 500
    Return

MidiNoteOff21:
    SetTimer, repeatJ, Delete
    Send {j up}
    Return

repeatK:
    Send {k down}
    if (repeatKFirst){
        repeatKFirst:=false
        SetTimer, , 10
    }
    Return

MidiNoteOn22:
    repeatKFirst:=true
    Send {k down}
    SetTimer, repeatK, 500
    Return

MidiNoteOff22:
    SetTimer, repeatK, Delete
    Send {k up}
    Return

repeatL:
    Send {l down}
    if (repeatLFirst){
        repeatLFirst:=false
        SetTimer, , 10
    }
    Return

MidiNoteOn23:
    repeatLFirst:=true
    SetTimer, repeatL, 500
    Send {l down}
    Return

MidiNoteOff23:
    SetTimer, repeatL, Delete
    Send {l up}
    Return


/* $2::
    While (GetKeyState("2","p")){
        Send 2
        Sleep 100
    }
    return
*/

; Cut, Row2 Key1
MidiNoteOn16:
    ;Send {Ctrl down}{b}{Ctrl up}
    Send {Ctrl down}{\}{Ctrl up}
    Return

; Select nearest, Row2 Key2
MidiNoteOn17:
    Send {v}
    Return


; Select nearest clip, Row2 Key3
MidiNoteOn18:
    Send {Shift down}{v}{shift up}
    Return