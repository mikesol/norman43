s = Server.local
s.boot;

(
	SynthDef("buffer_reader",{arg out, bufnum, startpos, duration, speed;
	var buffy, env, envgen;
	buffy = PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum)/speed,startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	Out.ar(out,Pan2.ar(buffy)*envgen);
}).send(s);

	SynthDef("buffer_reader_pshift",{arg out, bufnum, startpos, duration, speed, shift, vol;
	var buffy, env, envgen;
	buffy = PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum)/speed,startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	Out.ar(out,Pan2.ar(PitchShift.ar(buffy, 0.2, Line.kr(shift, 1, duration)))*envgen * vol);
}).send(s);

	SynthDef("buffer_reader_saw",{arg out, bufnum, startpos, duration, ep;
	var buffy, env, envgen, saw;
	buffy = PlayBuf.ar(2,bufnum,Line.kr(1,ep,3),startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	saw = Saw.kr(SinOsc.kr(0.5, 0, 2, 5), 0.5, 0.5);
	Out.ar(out,Pan2.ar(buffy)*envgen* saw);
}).send(s);


	SynthDef("buffer_reader_saw_hi",{arg out, bufnum, startpos, ep;
	var buffy, env, envgen, saw;
	buffy = PlayBuf.ar(2,bufnum,Line.kr(1,ep,3),startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,BufDur.kr(bufnum)-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	saw = Saw.kr(SinOsc.ar(0.1,0,40,50), 0.5, 0.5);
	Out.ar(out,Pan2.ar(buffy)*envgen* saw);
}).send(s);

	SynthDef("buffer_reader_saw_ps",{arg out, bufnum, startpos, duration, ep;
	var buffy, env, envgen, saw;
	buffy = PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum),startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	saw = Saw.kr(SinOsc.kr(0.5, 0, 2, 5), 0.5, 0.5);
	Out.ar(out,Pan2.ar(PitchShift.ar(buffy, 0.2, Line.kr(1,ep,BufDur.kr(bufnum))))*envgen* saw);
}).send(s);

SynthDef("buffer_reader_no_no_no",{arg out, bufnum, startpos, duration, n1, n2;
	var buffy, env, envgen;
	buffy = PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum),startPos:startpos);
	env = Env.new([0.0,1.0,1.0,0.0],[0.01,duration-0.02,0.01],'linear');
	envgen = EnvGen.kr(env, doneAction:2);
	Out.ar(out,Pan2.ar(buffy + PitchShift.ar(buffy,0.2,n1) + PitchShift.ar(buffy,0.2,n1))*envgen);
}).send(s);

)

(
  b = [Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/c1.aif"),
		Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/c2.aif"),
		Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/c3.aif")];
)

(
  c = Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/bassy.aif");
  d = Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/high.aif");
)

b.free

(
Routine({
	40.do({

		Synth.new("buffer_reader_saw", [\out, 0, \bufnum, b[0], \startpos, 0, \duration, 4, \ep, 0.9 + 0.2.rand]);
		3.63.wait;
	});
}).play;
)

(
Routine({
	40.do({

     Synth.new("buffer_reader_no_no_no", [\out, 0, \bufnum, c, \startpos, 0, \duration, 3.63*2, \n1, 0.9, \n2, 1.4]);
		(3.63*2).wait;
	});
}).play;
)

Synth.new("buffer_reader_saw_hi", [\out, 0, \bufnum, d, \startpos, 0, \ep, 1.0]);