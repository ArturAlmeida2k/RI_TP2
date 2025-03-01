function [P,F] = bloco(WBL,LBL,HBL)

P =  [0   0   0
      WBL 0   0
      0   LBL 0
      WBL LBL 0
      0   0   HBL
      WBL 0   HBL
      0   LBL HBL
      WBL LBL HBL];

P = htrans(-WBL/2,-LBL/2,0) * [P';ones(1,size(P,1))];

F = [1 2 4 3
     1 3 7 5
     1 2 6 5
     5 6 8 7
     2 4 8 6
     3 4 8 7];

end