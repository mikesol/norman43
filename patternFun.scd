a = Pbind.new.play(quant:1.0);

Pbind(\freq, 440).play(quant:1.0);

(
Pbind(
	\dur,0.125,
	\midinote, Pseq([0, 4, 0, 7, 4, 0, 0] + 60,inf),
	\amp, Prand([0.125, 0.2, 0.25],inf)
).play(quant:1.0)
)


(
Pbind(
	\freq, Pseq([100,200,300],inf)       // try a different list
).play;
)

// loops through the sequence of the array, perpetually:
Pseq([0,1,2,3],inf)

// next value is a random member of the array, after 5 times stop:
Prand([0,1,2,3],5)

// next value is a random member of the array
// except you can't repeat the previous value:
Pxrand([0,1,2,3],inf)

// next value is a weighted choice from the first array
// using the weights given in the second argument.
// After returning one value, stop:
Pwrand([0,1,2,3], [0.5,0.3,0.1,0.1], 1)
// next value is the result of evaluating the
// given function, in this case 4.rand:
Pfunc({ 4.rand })

(
var a, x, y;

a = Pshuf([1, 2, 3], inf);
x = a.asStream;	// this creates a Routine from the Pattern.
y = a.asStream;
x.nextN(10).postln;
y.nextN(10);
)

(
var a =  Pshuf([1, 1, 0, 1, 0], 3);
Pbind(
	\dur, 0.125,
	\midinote, a * 7 + 60,
	\amp, a * 0.1
).play
)

Stream