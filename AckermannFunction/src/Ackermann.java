
class Ackermann {
	public static final int N_WINDOWS6 = 6;
	public static final int N_WINDOWS8 = 8;
	public static final int N_WINDOWS16 = 16;
	public static int overflows = 0;
	public static int underflows = 0;
	public static int maxWindowDepth = 0;
	public static int wUSED = 2;	
	public static int call = 0;

	public static int ackermann(int x, int y, int nWindows) {
		call++;
		if (x == 0) {
			if(wUSED == 2) {
				underflows++;
			} else wUSED--; 
			maxWindowDepth--;
			return y+1;
		} else if (y == 0) {
			if(wUSED == nWindows) {
				overflows++;
			} else wUSED++;
			maxWindowDepth++;
			return ackermann(x-1, 1, nWindows);
		} else {
			if(wUSED == nWindows) {
				overflows++;
			} else wUSED++;
			maxWindowDepth++;
			return ackermann(x-1, ackermann(x, y-1, nWindows), nWindows);
		}
	}
	
	public static void printAckermann(int nWindows) {
		long startTime = System.nanoTime();
		ackermann(3,6,nWindows); 
		long endTime = System.nanoTime();
		long runTime = endTime - startTime;
		System.out.println("Call: "+call+"\nWindow depth: "
				+""+maxWindowDepth+"\nRegister window: "+wUSED+
				"\nOverflows: "+overflows+"\nUnderflows: "
				+""+ (underflows+maxWindowDepth) +"\nTook: "+runTime+"ns");
		double tenP9 = Math.pow(10, 9);
		double toSeconds = runTime/tenP9;
		System.out.println("Took: "+toSeconds+"s\n");
	}
	
	public static void main(String[] args) {
		System.out.println("WITH 6 REGISTER WINDOWS");
		printAckermann(N_WINDOWS6);
		wUSED = 2;
		maxWindowDepth = 0;
		overflows = 0;
		underflows = 0;
		call = 0;
		System.out.println("WITH 8 REGISTER WINDOWS");
		printAckermann(N_WINDOWS8);
		wUSED = 2;
		maxWindowDepth = 0;
		overflows = 0;
		underflows = 0;
		call = 0;
		System.out.println("WITH 16 REGISTER WINDOWS");
		printAckermann(N_WINDOWS16);
	}
}