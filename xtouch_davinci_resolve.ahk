/*
 *
 * Behringer X-TOUCH Mini MIDI 2 Davinci Resolve ShortCut using ahk
 * 
 * (C) 2021 by Folke Ashberg, github.com/fashberg
 * 
 */

#include AutoHotkey-Midi/Midi.ahk
#include miditools.ahk

#Persistent

midi := new Midi()
ok:=true
if (midi.OpenMidiOutByName( "X-TOUCH MINI" )<0){
    ok:=false
}
if (midi.OpenMidiInByName( "X-TOUCH MINI" )<0){
    ok:=false
}

if (!ok){
    MsgBox, Cannot open MIDI Device
    midi.Destroy()
    ExitApp, 1
}

; switch to standard mode (versus MC-Mode)
midi.MidiOut("CC", 1, 127, 0)

; clear all buttons and say hello
; Layer A
midi.MidiOut("PC", 1, 0, 0)
Loop 2 { 
    int:=0
    Loop 16 { 
        ; button on
        midi.MidiOut("N1", 1, int, 1)
        int++
        sleep 20
    }
    int:=0
    Loop 16 { 
        ; button off
        midi.MidiOut("N1", 1, int, 0)
        int++
        sleep 20
    }
    ; Layer B
    midi.MidiOut("PC", 1, 1, 0)
}
; Layer A
midi.MidiOut("PC", 1, 0, 0)

Gosub, ProcessSound
;ProcessSound,

isShift := false
knob1 := new MidiKnob("knob1")
knob2 := new MidiKnob("knob2")
knob3 := new MidiKnob("knob3")
knob4 := new MidiKnob("knob4")
knob5 := new MidiKnob("knob5")
knob6 := new MidiKnob("knob6")
knob7 := new MidiKnob("knob7")
knob8 := new MidiKnob("knob8")

keyrepeatJ := new MidiRepeat("keyrepeatJ")
keyrepeatK := new MidiRepeat("keyrepeatK")
keyrepeatL := new MidiRepeat("keyrepeatL")


oldSound:=0
SetTimer, ProcessSound, 1800, -1000


Return  ; end of MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; called periodically by timer
; reads master volume and sets knob
ProcessSound:
    ;; get current master volume and set wheel 8
    SoundGet, master_volume
    snd := master_volume/100*127
    if (snd!=oldSound){
        OutputDebug, Sound Vol: %master_volume% / %snd%`r`n
        midi.MidiOut("CC", 11, 8, snd)
        oldSound:=snd
    }
Return

;  KNOBS

; KNOB 1
; JOG
MidiControlChange1:
    knob1.CalledCC(midi.MidiIn())
    Return
knob1left(midi){
    global isShift
    if (!isShift){
        Send {left}
    } else {
        Send +{left}
    }
}
knob1right(midi){
    global isShift
    if (!isShift){
        Send {right}
    } else {
        Send +{right}
    }
}

; KNOB 2
; JOG-LONG
MidiControlChange2:
    knob2.CalledCC(midi.MidiIn())
    Return
knob2left(midi){
    global isShift
    if (!isShift){
        Send {Shift down}{left}{Shift up}
    } else {
        Send +{left 30}
    }
}
knob2right(midi){
    global isShift
    if (!isShift){
        Send {Shift down}{right}{Shift up}
    } else {
        Send +{right 30}      
    }
}

; KNOB 3
; JOG-CUT
MidiControlChange3:
    knob3.CalledCC(midi.MidiIn())
    Return
knob3left(midi){
    global isShift
    if (!isShift){
        Send {Up}
    } else {
        Send ^{WheelDown}
    }
}
knob3right(midi){
    global isShift
    if (!isShift){
        Send {Down}
    } else {
        Send ^{WheelUp}        
    }
}

; KNOB 4
; MOVE
MidiControlChange4:
    knob4.CalledCC(midi.MidiIn())
    Return
knob4left(midi){
    global isShift
    if (!isShift){
        Send {,}
    } else {
        Send +{,}
    }
}
knob4right(midi){
    global isShift
    if (!isShift){
        Send {.}
    } else {
        Send +{.}        
    }
}

; KNOB 5
; UNUSED
MidiControlChange5:
    knob5.CalledCC(midi.MidiIn())
    Return
knob5left(midi){
    global isShift
    if (!isShift){
        Send ^+{Down}
    } else {
        Send ^!{Down}
    }
}
knob5right(midi){
    global isShift
    if (!isShift){
        Send ^+{Up}
    } else {
        Send ^!{Up}        
    }
}

; KNOB 6
; JOG
MidiControlChange6:
    knob6.CalledCC(midi.MidiIn())
    Return
knob6left(midi){
    global isShift
    if (!isShift){
        Send {Numpad4}
    } else {
        Send {Numpad2}
    }
}
knob6right(midi){
    global isShift
    if (!isShift){
        Send {Numpad6}
    } else {
        Send {Numpad8}
    }
}

; KNOB 7
; ZOOM
MidiControlChange7:
    knob7.CalledCC(midi.MidiIn())
    Return
knob7left(midi){
    global isShift
    if (!isShift){
        Send {Ctrl down}{-}{Ctrl up}
    } else {
        Send +{WheelUp}
    }
}
knob7right(midi){
    global isShift
    if (!isShift){
        Send {Ctrl down}{=}{Ctrl up}
    } else {
        Send +{WheelDown}   
    }
}
; KNOB 7 pressed: reset zoom
MidiNoteOn6:
Send {Shift down}z{Shift up}
Return

; KNOB 8
; VOLUME
; Not using MidiKnob, because we want absolute value
MidiControlChange8:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC8 %ccValue%`r`n
    SoundSet ccValue/127 * 100
    Return

; Row1 Key1
; Select MODE
; 
MidiNoteOn8:
    if (!isShift){
        Send at
        ; switch row1/key2 off
        midi.MidiOut("N0", 1, 1, 0)
    } else {
    }
    Return
MidiNoteOff8:
    if (!isShift){
        ; switch row1/key1 on
        midi.MidiOut("N1", 1, 0, 1)
    } else {
    }   
    Return

; Row1 Key2
; TRIM MODE
; 
MidiNoteOn9:
    if (!isShift){
        Send t
        ; switch row1/key1 off
        midi.MidiOut("N0", 1, 0, 0)
    } else {
    }
    Return
MidiNoteOff9:
    if (!isShift){
        ; switch row1/key2 on
        midi.MidiOut("N1", 1, 1, 1)
    } else {

    }
Return

; Row1 Key3
; SLIP MODE
; 
MidiNoteOn10:
    if (!isShift){
        Send {w}
        if (!oldW){
            midi.MidiOut("N0", 1, 2, 0)
        }
        oldW:=!oldW
    } else {
    }
    Return
MidiNoteOff10:
    if (!isShift){
        if (oldW){
            midi.MidiOut("N1", 1, 2, 1)
        }
    } else {

    }
Return


; Row1 Key4
; SPLIT
; JOIN
MidiNoteOn11:
    if (!isShift){
        Send {Ctrl down}\{Ctrl up}
    } else {
        Send {Alt down}\{Alt up}
    }
    Return

; Row1 Key5
; INSERT
;
MidiNoteOn12:
    if (!isShift){
        Send {F9}
    } else {
    }
    Return

; Row1 Key6
; INSERT
;
MidiNoteOn13:
    if (!isShift){
        Send {F10}
    } else {
        Send {Shift down}{F10}{shift up}
    }
    Return

; Row1 Key7
; INSERT
;
MidiNoteOn14:
    if (!isShift){
        Send {F11}
    } else {
        Send {Shift down}{F11}{shift up}
    }
    Return

; Row1 Key8
; INSERT
;
MidiNoteOn15:
    if (!isShift){
        Send {F12}
    } else {
        Send {Shift down}{F12}{shift up}
    }
    Return


; Row2 Key1
; SHIFT
MidiNoteOn16:
    isShift:=true
    Return
MidiNoteOff16:
    isShift:=false
    Return

; Row2 Key2
; Select nearest CLIP
; Select nearest TRANSITION
MidiNoteOn17:
    if (!isShift){
        Send {Shift down}v{shift up}
    } else {
        Send v
    }
    Return

; Row2 Key3
; SET IN
; CLEAR IN
MidiNoteOn18:
    if (!isShift){
        Send i
    } else {
        Send {Alt down}i{Alt up}
    }
    Return

; Row2 Key4
; SET OUT
; CLEAR OUT
MidiNoteOn19:
    if (!isShift){
        Send o
    } else {
        Send {Alt down}o{Alt up}
    }
    Return

; Row2 Key5
; UNDO
; REDO
MidiNoteOn20:
    if (!isShift){
        Send {Ctrl down}z{Ctrl up}
    } else {
        Send {Ctrl down}{Shift down}z{Shift up}{Ctrl up}
    }
    Return

; keys JKL need to repeat

; Row2 Key6
; Reverse (J)
MidiNoteOn21:
    keyrepeatJ.calledNoteOn(midi.MidiIn())
    Return
MidiNoteOff21:
    keyrepeatJ.calledNoteOff(midi.MidiIn())
    Return
keyrepeatJfirst(midi){
    Send {j down}
}
keyrepeatJrepeat(midi){
    Send {j down}
}
keyrepeatJstop(midi){
    Send {j up}
}

; Row2 Key7
; STOP (K)
MidiNoteOn22:
    keyrepeatK.calledNoteOn(midi.MidiIn())
    Return
MidiNoteOff22:
    keyrepeatK.calledNoteOff(midi.MidiIn())
    Return
keyrepeatKfirst(midi){
    Send {k down}
}
keyrepeatKrepeat(midi){
    Send {k down}
}
keyrepeatKstop(midi){
    Send {k up}
}

; Row2 Key8
; Forward/PLAY (L)
MidiNoteOn23:
    keyrepeatL.calledNoteOn(midi.MidiIn())
    Return
MidiNoteOff23:
    keyrepeatL.calledNoteOff(midi.MidiIn())
    Return
keyrepeatLfirst(midi){
    Send {l down}
}
keyrepeatLrepeat(midi){
    Send {l down}
}
keyrepeatLstop(midi){
    Send {l up}
}