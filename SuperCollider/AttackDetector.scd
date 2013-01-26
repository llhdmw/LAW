(
s = Server.local;
~threshTest = nil;
s.waitForBoot({

	SynthDef(\threshTest, {
		arg thresh=(-30);
		var sig, amp, trig;
		sig = SoundIn.ar(0);
		amp = Amplitude.kr(sig).ampdb;
		amp = K2A.ar(amp);
		trig = amp >= thresh;
		SendReply.ar(Impulse.ar(50), 'trigVal', [trig]);
	}).add;

	w = Window.new("Attack Detector", Rect(200, 250, 155, 65)).front;
	w.view.background_(Color.gray(0.75));
	w.onClose_({s.freeAll});

	~numberBox = NumberBox.new(w, Rect(51, 25, 55, 25))
		.font_(Font("Helvetica", 16))
		.value_(-30)
		.action_({
			|nb|
			nb.value.postln;
			~knob.value_((nb.value.dbamp) / (~maxValSlider.value.dbamp));
			if(~threshTest.notNil,
				{
					if(~threshTest.group.class == Group,
						{~threshTest.set(\thresh, nb.value)},
						{}
						);
				},
				{}
			);
		});

	~knob = Knob.new(w, Rect(0, 0, 50, 50))
	.background_(Color.gray(0.75))
	.color_([Color.blue(0.9,0.5), Color.green(0.65), Color.gray(0.6), Color.black])
	.value_(~numberBox.value.dbamp)
	.action_({
		|knob|
		~numberBox.valueAction_((knob.value * ~maxValSlider.value.dbamp).ampdb);
	});

	~maxValSlider = EZSlider(
		w, Rect(-3, 48, 163, 20),nil,
		ControlSpec.new(-90,0,\lin,0.1,0,""),
		{
			|slider|
			~numberBox.valueAction_((~knob.value * slider.value.dbamp).ampdb)
		},
		1, false, 0, 0, 0, 0, \horz, 2@2, 2@2
	)
	.setColors(knobColor:Color.blue(0.9,0.5))
	.font_(Font("Helvetica", 16));

	~testButton = Button.new(w, Rect(51, 0, 55, 25))
	.states_([
		["ON", Color.white, Color.green(0.65)],
		["OFF", Color.white, Color.red(0.65)]
	])
	.action_({
		|but|
		case
		{but.value == 0} {~threshTest.free}
		{but.value == 1} {~threshTest = Synth(\threshTest, [\thresh, ~numberBox.value])};
	})
	.font_(Font("Helvetica", 16));


	w.drawFunc = {
		|v|
		Pen.fillColor = Color.gray(0.75);
		Pen.strokeColor = Color.black;
		Pen.width = 3;
		Pen.addArc(130@25, 20, 0, 2pi);
		Pen.fillStroke;
	};
	w.refresh;

	~oscr1.remove;

	~oscr1 = OSCresponder(nil, 'trigVal', {
		|time, resp, msg|
		if(
			msg[3] == 1,
			{
				Routine {
					w.drawFunc = { |v|
						Pen.fillColor = Color.green;
						Pen.strokeColor = Color.black;
						Pen.width = 3;
						Pen.addArc(130@25, 20, 0, 2pi);
						Pen.fillStroke;
					};
					w.refresh;
					0.1.wait;
					w.drawFunc = { |v|
						Pen.fillColor = Color.gray(0.75);
						Pen.strokeColor = Color.black;
						Pen.width = 3;
						Pen.addArc(130@25, 20, 0, 2pi);
						Pen.fillStroke;
					};
					w.refresh;
				}.play(AppClock);
			},
			{}
		);
	}).add;
})
)