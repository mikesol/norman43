// entries in the form
// [beg, end, rate]
// if rate is ommitted, assumed to be 1.0
// functions build the array
// then passed to simple synthdef


(
play({Pan2.ar(Mix.ar(Array.fill(32,{|i| SinOsc.ar(200*i,0,1.0/32)})))})
)

(
play({Pan2.ar(Mix.ar(Array.fill(32,{|i| SinOsc.ar(200*i,0,2**(-1*(2+i)))})))})
)

(
play({Pan2.ar(Mix.ar(Array.fill(32,{|i| SinOsc.ar(200*i,0,SinOsc.kr(2**i,0,2**(-1*(2+i))))})))})
)


s = Server.local
s.boot;

(
	SynthDef("buffer_reader",{arg out, bufnum, startpos, duration, speed;
	var buffy, env, envgen;
	buffy = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum)/speed,startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	Out.ar(out,Pan2.ar(buffy)*envgen);
}).send(s);

	SynthDef("buffer_reader_pshift",{arg out, bufnum, startpos, duration, speed, shift, vol;
	var buffy, env, envgen;
	buffy = PlayBuf.ar(1,bufnum,BufRateScale.kr(bufnum)/speed,startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	Out.ar(out,Pan2.ar(PitchShift.ar(buffy, 0.2, Line.kr(shift, 1, duration)))*envgen * vol);
}).send(s);
)

{
  q = Buffer.read(s, "/Users/mikesolomon/Desktop/fichier_olivier_10c.aiff");
}



(
		Routine {
100.do({|x|
		var dur = 0.05 + 0.5.rand;
		var sp = q.numFrames * 1.0.rand;
20.rand.do({|y|
var spd = 0.5 + 1.0.rand;
				Synth.new("buffer_reader_pshift", [\out, 0, \bufnum, q, \startpos, sp, \duration, dur, \speed, spd, \shift, 1.2 + 0.5.rand, \vol, 0.4]);
	Synth.new("buffer_reader", [\out, 0, \bufnum, q, \startpos, sp, \duration, dur, \speed, spd]);
		dur.wait;
		});
});}.play;
)

(
		Routine {
100.do({|x|
	var dur = 0.3+0.1.rand;
		var sp = b.numFrames * 1.0.rand;
5.rand.do({|y|
var spd = 0.5 + 1.0.rand;
	Synth.new("buffer_reader_pshift", [\out, 0, \bufnum, b, \startpos, sp, \duration, dur, \speed, spd, \shift, 1.0 + 0.5.rand, \vol, 0.5]);
	Synth.new("buffer_reader", [\out, 0, \bufnum, b, \startpos, sp, \duration, dur, \speed, spd]);
	Synth.new("buffer_reader_pshift", [\out, 0, \bufnum, b, \startpos, sp, \duration, dur, \speed, spd, \shift, 0.5 + 0.5.rand, \vol, 0.5]);
		dur.wait;
		});
});}.play;
)

s.prepareForRecord("/Users/mikesolomon/Documents/Compositions/norman43/bible/sketches/happy_rabbi_6.aiff");
s.record;
s.stopRecording; // this closes the file and deallocates the buffer recording node, etc.

b.numFrames