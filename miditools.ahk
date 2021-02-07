

; MidiKnob interface
; for endless knob which returns values 0..127
; and if on left or right 0 or 127 gets repeated
; we call <name>left or <name>right if rotated
Class MidiKnob
{
  ; Instance creation
  __New(name)
  {
    this.lastvalue:=65
    this.name:=name

  }

  ; Instance destruction
  __Delete()
  {

  }

  calledCc(midi){
    ccValue := midi.value
    OutputDebug, CC1 %ccValue%`r`n
    if (ccValue>this.lastvalue or ccValue==127){
      labelNameSuffix:="right"
    } else if (ccValue<this.lastvalue or ccValue==0){
      labelNameSuffix:="left"
    }
    labelName:=this.name labelNameSuffix
    If IsFunc( labelName )
      %labelName%(midi)
    this.lastvalue:=ccValue
  }

}




; MidiRepeat interface
; runs <name>first if pressed
; starts to repeat <name>repeat after 500ms at interval of 10ms
; if midioff comes start <name>stop
Class MidiRepeat
{
  ; Instance creation
  __New(name)
  {
    this.state:=0
    this.name:=name
    this.timer := ObjBindMethod(this, "fire")

  }

  ; Instance destruction
  __Delete()
  {

  }

  fire(){
    timer := this.timer
    if (this.state==0){
      return
    } else if (this.state==1){
      labelNameSuffix:="first"
      this.state:=2
      SetTimer % timer, 500
    } else if (this.state==2){
      labelNameSuffix:="repeat"
      SetTimer % timer, 10
    } else if (this.state==3){
      labelNameSuffix:="stop"
      SetTimer % timer, Off
    }
    labelName:=this.name labelNameSuffix
    If IsFunc( labelName )
      %labelName%(midi)

    if (this.state==3){
      this.state:=0
    }
  }

  calledNoteOn(midi){
    if (this.state==0){
      this.state:=1
    }
    this.fire()
  }
  calledNoteOff(midi){
    this.state:=3
    this.fire()
  }

}
