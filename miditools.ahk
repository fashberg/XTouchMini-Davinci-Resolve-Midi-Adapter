

; Midi class interface
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



; Midi class interface
Class MidiRepeat
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
  calledNoteOn(midi){
    
  }
  calledNoteOff(midi){
    
  }

}
