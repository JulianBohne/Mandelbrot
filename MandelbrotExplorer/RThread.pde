class RThread extends Thread{
  double maxIt;
  ArrayList<Task> tasks = new ArrayList<Task>();
  
  RThread(double maxIt){
    this.maxIt = maxIt;
  }
  
  void run(){
    for(int i = 0; i < tasks.size(); i ++) while(!tasks.get(i).compute()){};//println(tasks.get(i).it);}
  }
  
  void addTask(double a, double b, int index){
    tasks.add(new Task(maxIt,a,b,index));
  }
}
