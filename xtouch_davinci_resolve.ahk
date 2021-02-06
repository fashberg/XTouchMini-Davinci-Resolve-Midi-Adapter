#include AutoHotkey-Midi/Midi.ahk
;#include AutoHotkey-Midi/MidiOut.ahk
;#include AutoHotkey-Midi/Midiout2.ahk

 
midi := new Midi()
midi.OpenMidiIn( 0 )
h:=midi.OpenMidiOut( 1 )

name := midiOut.getDeviceName()
OutputDebug, MidiOutName: %name%`r`n

SoundGet, master_volume
OutputDebug, Sound Vol: %master_volume%`r`n
snd := master_volume/100*127
OutputDebug, Sound Vol: %master_volume% / %snd%`r`n

midi.MidiOut(h, "N1", 1, 0, 1)

Return

MidiNoteOnA4:
    MsgBox You played note A4!
    Return

MidiControlChange1:
    cc := midi.MidiIn()
    ccValue := cc.value
    ;MsgBox You set the mod wheel to %ccValue%
    OutputDebug, CC1 %ccValue%`r`n
    Return

MidiControlChange8:
    cc := midi.MidiIn()
    ccValue := cc.value
    OutputDebug, CC8 %ccValue%`r`n
    SoundSet ccValue/127 * 100
    Return