class Task{
  double maxIt;
  double sa, sb, ca, cb;
  double it;
  int index;
  Task(double maxIt, double a, double b, int index){
    this.maxIt = maxIt;
    this.sa = a;
    this.sb = b;
    this.ca = 0;
    this.cb = 0;
    this.it = 0;
    this.index = index;
  }
  boolean compute(){
    if(it < maxIt){
      double na = ca*ca-cb*cb+sa;
      double nb = 2*ca*cb+sb;
      ca = na;
      cb = nb;
      if(ca*ca+cb*cb > 4) return true;
      it ++;
      return false;
    }else return true;
  }
}
