s.reboot; //    jmess -c RtoS

(
b = Buffer.alloc(s,2048,1);
c = Buffer.alloc(s,2048,1);
)


(
SynthDef("help-morph", { arg out=0, bufnumA=0, bufnumB=1;
	var inA, chainA, inB, chainB, chain;
	inA = SoundIn.ar(2);
	inB = SoundIn.ar(3);
	chainA = FFT(bufnumA, inA);
	chainB = FFT(bufnumB, inB);
	//chain = PV_Morph(chainA, chainB, MouseX.kr);

	//chain = PV_Diffuser(chainA, MouseY.kr > 0.5 );
	//chain = PV_MagSmooth(chainA, 1 - MouseX.kr(1, 0.00001, 1));
	chain = PV_BinScramble(chainA, MouseX.kr , 0.1, MouseY.kr > 0.5 );

	//chain = PV_ConformalMap(chainA, MouseX.kr(-1.0,1.0), MouseY.kr(-1.0,1.0));
	//chain = PV_MagBelow(chainA, MouseX.kr(0, 7));

	//chain = PV_MagFreeze(chainA, SinOsc.kr(0.2) );
	Out.ar(out, IFFT(chain).dup);
}).play;
)




VocodeBand.ar()





















