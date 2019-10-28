
class Ackermann {
	public static int nWINDOWS = 0;
	public static int overflows = 0;
	public static int underflows = 0;
	public static int maxWindowDepth = 0;
	public static int registerWindowDepth = 1;
	public static int wUSED = 3;	
	public static int call = 0;

	public static int ackermann(int x, int y) {
		call++;
		if (x == 0) {
			underflowHandler();
			return y+1;
		} else if (y == 0) {
			overflowHandler();
			int result = ackermann(x-1, 1);
			underflowHandler();
			return result;
		} else {
			overflowHandler();
			int firstRecursion = ackermann(x, y-1);
			overflowHandler();
			int secondRecursion = ackermann(x-1, firstRecursion);
			underflowHandler();
			return secondRecursion;
		}
	}

	public static void overflowHandler() {
		registerWindowDepth++;
		if(registerWindowDepth>maxWindowDepth)
			maxWindowDepth = registerWindowDepth;
		if(wUSED == nWINDOWS)
			overflows++;
		else wUSED++;
	}
	
	public static void underflowHandler() {
	 registerWindowDepth--;
	 if(wUSED == 2)
		 underflows++;
	 else wUSED--;
	}
	
	public static void printAckermann(int nWindows) {
		nWINDOWS = nWindows;
		int result = ackermann(3,6);
		System.out.println("Call            : "+call+"\nResult          : "
		+result+"\nMAX window depth: "+""+maxWindowDepth+"\nRegister window : "+wUSED+
		"\nOverflows       : "+overflows+"\nUnderflows      : "+underflows);
	}
	
	public static void averageRuntime() {
		long runTime = 0;
		int result = 0;
		for(int i = 0; i < 100; i++) {
			long startTime = System.nanoTime();
			result = ackermann(3,6); 
			long endTime = System.nanoTime();
			runTime += endTime - startTime;
		}
		runTime = runTime/100;
		System.out.println("Average runtime : "+runTime+"ns\n");
	}

	public static void main(String[] args) {
		System.out.println("WITH 6 REGISTER WINDOWS");
		printAckermann(6);
		averageRuntime();
		wUSED = 3;
		maxWindowDepth = 0;
		overflows = 0;
		underflows = 0;
		call = 0;
		registerWindowDepth = 1;
		System.out.println("WITH 8 REGISTER WINDOWS");
		printAckermann(8);
		averageRuntime();
		wUSED = 3;
		maxWindowDepth = 0;
		overflows = 0;
		underflows = 0;
		call = 0;
		registerWindowDepth = 1;
		System.out.println("WITH 16 REGISTER WINDOWS");
		printAckermann(16);
		averageRuntime();
	}
}
/*
* WITH 6 REGISTER WINDOWS
* Call            : 172233
* Result          : 509
* MAX window depth: 511
* Register window : 2
* Overflows       : 84885
* Underflows      : 84885
* Average runtime : 838374ns

* WITH 8 REGISTER WINDOWS
* Call            : 172233
* Result          : 509
* MAX window depth: 511
* Register window : 2
* Overflows       : 83911
* Underflows      : 83911
* Average runtime : 689734ns

* WITH 16 REGISTER WINDOWS
* Call            : 172233
* Result          : 509
* MAX window depth: 511
* Register window : 2
* Overflows       : 80142
* Underflows      : 80142
* Average runtime : 796988ns
*/

/* For my implementation I followed the pseudo code on the slides for the underflow and overflow 
 * handling methods. Every time there is a function call, I call the overflow handler and everytime
 * there is a function exit I call the underflow handler. I start with two register windows currently
 * being used because two must being used at all times. Added in extra parameter for ackermann function
 * that, passes in the number of register windows being used. For the running time of each different
 * register window size, I ran the ackermann function 100 times and got the average running time from that
 * so it is fairly accurate. This was done in the averageRuntime() function and the time returned is in 
 * nanoseconds. I assume that the processor handles the CWP and SWP movements and that all runs under the hood.
 */