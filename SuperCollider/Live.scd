s.reboot

(~inbus1 = Bus.audio(s);    ~input1={Out.ar(~inbus1,SoundIn.ar(0))}.play;    ~ctrl1 = Bus.control(s, 1);
 ~inbus2 = Bus.audio(s);    ~input2={Out.ar(~inbus2,SoundIn.ar(0))}.play;    ~ctrl2 = Bus.control(s, 1);)

(~pFollow1 = Synth.after(~input1,"pitchFollow",[\INbus, ~inbus1,\OUTbus, ~ctrl1]);
 ~pFollow2 = Synth.after(~input2,"pitchFollow",[\INbus, ~inbus2,\OUTbus, ~ctrl2]);)


(
SynthDef.new("pitchFollow",{arg INbus =0, OUTbus=0;
    var in, freq, hasFreq;
    in = In.ar(ibus);
    # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 7);
    //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
    Out.kr(obus, freq);
}).add;
)

(
SynthDef.new("Osc",{arg freq=0;
    Out.ar([0,1], LFSaw.ar(freq,0,1));
}).add;
)

x= Synth.new("Osc");
x.map(\freq, ~ctrl1);
