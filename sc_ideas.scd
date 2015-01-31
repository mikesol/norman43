// use noise as rate reader w/ severe lag
// changing bank of filters at rhythm on repeating or long sound
// -- this change can hopefully produce cool microrhythms
// skipping at regular rate in sound (already implemented)



b.free
(
//this loads into a buffer the default sound that comes with SuperCollider
//.read brings in the whole sound at once


SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1;
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(2,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(b[0].bufnum)*startPos, loop),0.0)
	)
}).add;
)

//make a new control Synth, playing on control buses
(
SynthDef("playbufcontrols",{

	//control for retrigger (impulse with modulated rate)
	Out.kr(0,Impulse.kr(LFNoise0.kr(0.5, 5, 6)));

	//control for jump position in sample (any random frame)
	Out.kr(1,LFNoise0.kr(0.25,0.5,0.5));

}).play(s);
)

a=Synth(\playbuf, [\out, 0, \bufnum, b[0].bufnum, \rate, 1, \trigger, "c0", \startPos, "c1"]);

//showing unmapping of control signals- unmap the modulation of jump position when retriggered, it will now be fixed
a.set(\startPos,"c")

//set fixed chosen start frame
a.set(\startPos,30000)