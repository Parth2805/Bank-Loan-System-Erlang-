import java.util.*;
import java.io.*;



public class money {
	
	
	static ArrayList<String> cnames = new ArrayList<>();
	static ArrayList<Integer> cvalues = new ArrayList<>();
	static ArrayList<String> bnames = new ArrayList<>();
	static ArrayList<Integer> bvalues = new ArrayList<>();
	static ArrayList<mycustomer> mi = new ArrayList<>();
	static ArrayList<banks> bil =  new ArrayList<>();
	//static int count=0;
	
	void customers() throws IOException, InterruptedException {
		
		File fr= new File("customers.txt");
		
		FileReader fir = new FileReader(fr);
		
		BufferedReader br = new BufferedReader(fir);
		
		String i=br.readLine();
		System.out.println("--------Customers---------");
		while(i!=null) {
			
			String main=i.substring(1, i.length()-2);
			
			
			System.out.println(main);
		
			String words[]=main.split(",");
			cnames.add(words[0]);
			cvalues.add(Integer.parseInt(words[1]));
			i=br.readLine();
		
		}
		br.close();
		
		
		File frb= new File("banks.txt");
		
		FileReader firb = new FileReader(frb);
		
		BufferedReader brb = new BufferedReader(firb);
		
		String bi=brb.readLine();
		System.out.println("--------Banks---------");
		while(bi!=null) {
			
			String main=bi.substring(1, bi.length()-2);
			
			
			System.out.println(main);
		
			String words[]=main.split(",");
			bnames.add(words[0]);
			bvalues.add(Integer.parseInt(words[1]));
			bi=brb.readLine();
		
		}
		
		
		
		for(int j=0;j<cvalues.size();j++) {
			
			
			mycustomer m = new mycustomer(j);
			mi.add(m);
			
		}
		
		for(int j=0;j<bvalues.size();j++) {
			
			banks b = new banks(j);
			bil.add(b);
			
		}
		
		
		
		
	}
	
	class banks extends Thread{
		
		 public int balance;
		
		banks(int i){
			
			balance=bvalues.get(i);
		}
		
		public void run() {
			
			while(true) {
				
				
				
			}
		}
		
		
		
	}
	
	class mycustomer extends Thread{
		
		int ci;
		int approved;
		ArrayList<Integer> list = new ArrayList<>();
		mycustomer(int x){
			
			ci=x;
			approved=0;
			
			
		}
		
		public void run() {
			
			try {
				get_loan(ci,list);
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			
		}
			
			
			
			
		
		
		
		
	}
	
	void get_loan(int i,ArrayList<Integer> list) throws InterruptedException {
		
		Random rand = new Random();
		int banki=0;
		int flag=0;
		boolean granted=false;
		
		int a[]=new int[bvalues.size()];
		
		do {
			
			
			banki=rand.nextInt(bvalues.size());
		//	System.out.println("New bank:"+bnames.get(banki));
			if(list.contains(banki)) {
				
			//	System.out.println(bnames.get(banki)+"rejected request of loan"+cnames.get(i));
								
			}
			else {
				
				
				while(true) {
					Thread.sleep(100);
					flag=0;
					int get;
					if(cvalues.get(i)>=50) {
						
						get=1+rand.nextInt(50);
						
					}
					else {
						
						get=1+rand.nextInt(cvalues.get(i));
						
					}
					
					System.out.println(cnames.get(i)+" requested loan of "+get+" dollar(s) from "+bnames.get(banki));
				
					if(bil.get(banki).balance>=get) {
					
						int update=bvalues.get(banki)-get;
						bvalues.set(banki, update);
						bil.get(banki).balance -= get;
						
						int update2=cvalues.get(i)-get;
						cvalues.set(i,update2);
						mi.get(i).approved=mi.get(i).approved+get;
						if(cvalues.get(i)==0) {
							
							granted=true;
					//		count++;
						//	System.out.println(count+"----------");
					//		System.out.println("Got full loan to:"+cnames.get(i));
							System.out.println(bnames.get(banki)+" approves loan of "+get+" dollar(s) to "+cnames.get(i));
							return;
							
						}
						
						
						System.out.println(bnames.get(banki)+" approves loan of "+get+" dollar(s) to "+cnames.get(i));
						
					}
					
					else {
						System.out.println(bnames.get(banki)+" rejected request of loan "+get+" from "+cnames.get(i));
						a[banki]++;
						list.add(banki);
						flag=1;
						break;	
					}
				
				//Thread.sleep(100);
			  }	
			}
			
			
			
			
		}while(list.size()<bvalues.size()||granted==true);
		
		
		
		
//	count++;
//	System.out.println(count+"----------");
	//	System.out.println("Done");
		
	}	
	
	
	
	money() throws IOException, InterruptedException{
		
		customers();
		
		
	}
	
		
		
		
		
		
		
		
		
	

	public static void main(String[] args) throws IOException, InterruptedException {
		
		
		
		HashMap<String,Integer> a = new HashMap<>();
		
		money p = new money();
		for(int i=0;i<bvalues.size();i++) {
			
			bil.get(i).start();
			
			
		}
		
		
		int original[] = new int[cnames.size()];
		for(int i=0;i<cvalues.size();i++) {
			
		//	System.out.println(cvalues.get(i));
			original[i]=cvalues.get(i);
			
		}
		
		for(int i=0;i<cnames.size();i++) {
			
			mi.get(i).start();
			
			
		}
		System.out.println();
		
		Thread t = Thread.currentThread();
		t.join(1500);
		
		
		
		System.out.println("----------");
		System.out.println();
		for(int i=0;i<cnames.size();i++) {
			
			
			System.out.println(cnames.get(i)+" got "+mi.get(i).approved+"Woo Hoo!!!.");
			
			
		}
		System.out.println();
		for(int i=0;i<bnames.size();i++) {
			
			
			System.out.println(bnames.get(i)+" has left "+bil.get(i).balance+" dollar(s).");
			
			
		}
		
		
		
		
		
		

	}

}
