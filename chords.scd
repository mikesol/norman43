(
Server.default= s=Server.internal;
s.waitForBoot({
s.scope;
FreqScope();
});
)

s.boot
(

SynthDef(\justone, {|buf, out=0, vol=1, fade=0.2|
	var i = 1;
	var foo = 0.9 + (0.05 * i);
	Out.ar(out, Lag.kr(vol,5.0)*
		SinOsc.kr(fade + (i * 0.1), 0, 0.4, 0.6) * Pan2.ar(PlayBuf.ar(1, buf, BufRateScale.kr(buf)*Lag.kr(Demand.kr(Impulse.kr((i+1)*0.4),0,Drand([0.5,0.9,1.0,1.2,1.7], inf)), 0.2), loop:1),0.0));
}).send(s);

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
b.free;
  b = [Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/c1.aif"),
		Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/c2.aif"),
		Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/c3.aif")];
)

(
c.free;
d.free;
e.free;
f.free;
m.free;
n.free;
  c = Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/bassy.aif");
  d = Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/high.aif");
e = Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/love.aif");
f = Buffer.read(s, "/Users/mikesolomon/Documents/Compositions/norman43/hazebrouck/Bounces/crystal.aif");

m = Buffer.alloc(s,2048,1);
n = Buffer.alloc(s,2048,1);


)



(
Routine({
	40.do({|i|
		var cap = 0.2 + 0;//(i/60.0);
		Synth.new("buffer_reader_saw", [\out, 0, \bufnum, b[0], \startpos, 0, \duration, 4, \ep, 0.9 + cap.rand]);
		3.63.wait;
	});
}).play;
)

s.prepareForRecord("/Users/mikesolomon/Documents/Compositions/norman43/spew/ex3.wav");
s.record;
s.stopRecording; // this closes the file and deallocates the buffer recording node, etc.

(
Routine({
	40.do({

     Synth.new("buffer_reader_no_no_no", [\out, 0, \bufnum, c, \startpos, 0, \duration, 3.63*2, \n1, 0.9, \n2, 1.4]);
		(3.63*2).wait;
	});
}).play;
)

Synth.new("buffer_reader_saw_hi", [\out, 0, \bufnum, d, \startpos, 0, \ep, 1.0]);


(
Routine({
	  80.do({
		var waitdur;
		waitdur = ([120.0, 60.0,60.0,60.0, 32.0,]/132.0).choose;
		Synth.new("buffer_reader", [\out, 0, \bufnum, e, \startpos, 0, \duration, waitdur, \speed, 1.0 - 0.08.rand]);
		waitdur.wait;
	});
}).play;
)

(
Routine({
	var fun = [[1.1,1.6,2.1,2.6],[1.2,1.3,1.4,1.7],[1.1,2.1,2.6,3.5],[1.1,1.2,1.3,1.4]];
	40.do({|i|
		play{PitchShift.ar(PlayBuf.ar(2,b[1],1), 0.2, Demand.kr(Impulse.kr(4/0.975),0,Dseq(fun[i.mod(4)],inf)))};
		(4/0.975).wait;
		"foo".postln;
	});
}).play;
)

Synth.new(\justone, [\buf, d, \out, 0, \vol, 1, \fade, 0.2]);

play{PitchShift.ar(PlayBuf.ar(2,b[1],1), 0.2, Demand.kr(Impulse.kr(4/0.975),0,Dseq([1.1,1.6,2.1,2.6],inf)))};

play{MonoGrain.ar(PitchShift.ar(PlayBuf.ar(2,f,1), 0.2, SinOsc.kr(100,0,0.4,1.2)), SinOsc.kr(20,0,0.005, 0.045), SinOsc.kr(10,0,5,15))};
// with pitch shift and double sin slinky

play{CombC.ar(PitchShift.ar(PlayBuf.ar(2,d,1).softclip, 0.2, SinOsc.kr(10,0,0.05,0.7)),1,1/SinOsc.kr(SinOsc.kr(1,0,[0.1,1]),0,30,90),1).dup}//easy hall/resonator fx for my lap steel guitar #supercollider

// d and b[0] and f are good
play{t=Impulse.kr(14.0/3.0);PlayBuf.ar(2,d,1,t,Demand.kr(t,0,Dseq(1e3*Array.fill(8,{(Array.fill(8,{15+400.rand})!4).flatten}).flatten,inf)))!2}
play{t=Impulse.kr(14.0/3.0);PlayBuf.ar(2,b[0],Demand.kr(t,0,Dseq(Array.fill(8,{(Array.fill(8,{0.9+0.2.rand})!4).flatten}).flatten,inf)),t,Demand.kr(t,0,Dseq(1e3*Array.fill(8,{(Array.fill(8,{15+400.rand})!4).flatten}).flatten,inf)))!2}

//e is GREAT
play{HPF.ar(Mix.ar(LFSaw.ar(SinOsc.kr(Array.rand(3,0.1,0.5),0,10,[1,1.1,1.5,1.78,2.45,6.7]*Tartini.kr(PlayBuf.ar(2,e,1, doneAction: 2))),0,0.3, 0.2)), 100).dup};
play{HPF.ar(Mix.ar(LFSaw.ar(SinOsc.kr(Array.rand(3,0.1,0.5),0,10,[1,1.1,1.5,1.78,]*Tartini.kr(PlayBuf.ar(2,e,1, doneAction: 2))),0,0.3, 0.2)), 100).dup};

// good with f
play{FreqShift.ar(PlayBuf.ar(2,f,1), SinOsc.kr(Line.kr(12,12,b[0].duration),0,50,100))};

// vanilla
play{PlayBuf.ar(2,b[0],BufRateScale.kr(b[2]), loop: 1)};


// shake it!
play{PlayBuf.ar(2,c,BufRateScale.kr(c)*Lag.kr(WhiteNoise.kr(0.2,1),0.05), loop: 1)};
play{PlayBuf.ar(2,b[2],BufRateScale.kr(b[2])*Lag.kr(WhiteNoise.kr(0.2,1),0.05), loop: 1)};
play{PlayBuf.ar(2,b[2],BufRateScale.kr(b[2])*Lag.kr(WhiteNoise.kr(0.2,1),0.05), loop: 1)};

// hardcore glitch
play{PlayBuf.ar(2,e,BufRateScale.kr(e), Impulse.kr(SinOsc.kr(1,0,50,50)), WhiteNoise.kr * BufDur.kr(e)*BufSampleRate.kr(e))};

// frizzzzn
play{Klank.ar(`[[400,600,700],[0.05,0.05,0.05],[5,5,5]], PlayBuf.ar(2,e,BufRateScale.kr(b[2]), loop: 1))};

(
{
    var q, sf, g;
	    sf = LFNoise0.ar(10);//LFNoise0.ar(MouseX.kr(1, 100, 1));
    g = 10;//MouseY.kr(0.1, 10, 1);
    q = Ball.ar(sf, g, 0.01, 0.01);
	    PlayBuf.ar(2,b[0],BufRateScale.kr(f)*(q+1), loop: 1);
}.play;
)

// end of the world scratchiness
play{Disintegrator.ar(PlayBuf.ar(2,b[0],BufRateScale.kr(b[2]), loop: 1),0.2,0)}

SVF
// BhobUgens are cool
// check out MCLDUgens too....

// top right of the screen to make vowel changes
(
z = SynthDef(\svf_test, { arg low=0.1, band=0.0, high=0.0, notch=0.0, peak=0.0;
    var sig;

    sig = SVF.ar(
		PlayBuf.ar(2,e,BufRateScale.kr(b[2]), loop: 1),
        //LFSaw.ar(LFSaw.kr(2).range(110,35)),    // signal

		MouseX.kr(20,20000,'exponential'),    // cutoff
        MouseY.kr(1.0,0,'linear'),        // q
        low, band, high, notch, peak);        // levels
    Out.ar(0, sig ! 2);
}).play(addAction: \addToTail);
)

// nasty click in beginning if not envd
// otherwise cool
play{EnvGen.kr(Env([0,0,1],[2,3]),1)*SMS.ar(PlayBuf.ar(2,e,BufRateScale.kr(b[2]), loop: 1),freqmult:1.0,freqadd:100)}


// freezy
(
{
    var in, chain;
	    in = PlayBuf.ar(2,e,BufRateScale.kr(e), loop: 1);
    chain = FFT(LocalBuf(2048), in);
    // moves in and out of freeze
	    chain = PV_MagFreeze(chain, SinOsc.kr(0.2) );
	    Pan2.ar(1.0 * IFFT(chain));
}.play;
)

// nice on e and d!
(
SynthDef("help-binScramble", { arg out=0, soundBufnum=2;
    var in, chain;
    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chain = FFT(LocalBuf(2048), in);
    chain = PV_BinScramble(chain, MouseX.kr , 0.1,  );
    Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s, [\soundBufnum, d]);
)

(
SynthDef("help-SoftWipe2", { arg out=0,bufnumA=0, bufnumB=1, soundBufnum=2, soundFun=3;
    var inA, chainA, inB, chainB, chain;
    inA = PlayBuf.ar(1, soundFun, BufRateScale.kr(soundFun), loop: 1);
    inB = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chainA = FFT(bufnumA, inA);
    chainB = FFT(bufnumB, inB);
	    chain = PV_SoftWipe(chainA, chainB, LFCub.kr(XLine.kr(0.25,25,10),0,1));
    Out.ar(out, 0.5 * IFFT(chain).dup);
}).play(s,[\out, 0, \bufnumA, m.bufnum, \bufnumB, n.bufnum, \soundBufnum, b[0],
	\soundFun, b[2]]);
)

// do eventually
//PV_BinDelay
