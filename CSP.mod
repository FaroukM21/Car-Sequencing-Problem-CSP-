/*********************************************
 * OPL 22.1.1.0 Model
 * Author: omeganet
 * Creation Date: 27 août 2024 at 11:34:35
 *********************************************/
int NbCar=...;
int NbSeq=...;
int NbO=...;
int BigM=100;
range Seq=1..NbSeq;
int N[j in 1..NbCar]=...;
int O[i in 1..NbO][j in 1..NbCar]=...;
int M[i in 1..NbO]=...;
int S[i in 1..NbO]=...;

dvar boolean delta[i in 1..NbSeq][j in 1..NbCar];
dvar boolean gamma[i in 1..NbSeq][j in 1..NbO];
dvar boolean kappa[i in 1..NbSeq][j in 1..NbSeq];

minimize sum(i in 1..NbSeq) (sum(j in 1..NbO) (gamma[i][j]));
subject to{
  /*forall(i in 1..NbSeq, j in 1..NbCar) delta[i,j]<=1;
  forall(i in 1..NbSeq, j in 1..NbO) gamma[i,j]<=1;
  forall(i in 1..NbSeq, j in 1..NbSeq) kappa[i,j]<=1;
  */
  forall(i in Seq ) sum(j in 1..NbCar) delta[i][j]==1;
  forall(j in 1..NbCar) sum(i in 1..NbSeq) delta[i][j]==N[j];
  
  forall(i in 1..NbSeq)
    forall(j in 1..NbSeq)
      kappa[i][j] - 1 <= (sum(k in 1..NbCar)delta[i][k]-sum(k in 1..NbCar)delta[j][k])/NbCar;
      
      
  forall(i in 1..NbSeq)
    forall(j in 1..NbSeq)
      kappa[i][j] - 1 <= (sum(k in 1..NbCar)delta[j][k]-sum(k in 1..NbCar)delta[i][k])/NbCar;
      
      
  //forall(j in 1..NbSeq, i in 1..NbSeq) kappa[i][j] - 1 <= sum(k in 1..NbCar)gamma[i][k]-sum(k in 1..NbCar)gamma[j][k];
  forall(j in 1..NbO,i in 1..NbSeq-S[j])
     {
      sum(k in i..i+S[j]-1) kappa[i,k] >= M[j]-BigM*(1-gamma[i,j]);
      sum(k in i..i+S[j]-1) kappa[i,k] <= M[j]+BigM*gamma[i,j];
    }      
  
  
  forall(j in 1..NbO)
    forall(i in NbSeq-S[j]..NbSeq)
      {
      sum(k in i..NbSeq) kappa[i,k] >= M[j]-BigM*(1-gamma[i,j]);
      sum(k in i..NbSeq) kappa[i,k] <= M[j]+BigM*gamma[i,j];
   }  	  
}