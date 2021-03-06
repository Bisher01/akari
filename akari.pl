/*=====initialize======*/

size(8,8).

wall(1,6).
wall(2,2).
wall(2,3).
wall(3,7).
wall(4,1).
wall(4,5).
wall(5,4).
wall(5,8).
wall(6,2).
wall(7,6).
wall(7,7).
wall(8,3).

wall_num(1,6,1).
wall_num(2,2,3).
wall_num(3,7,0).
wall_num(5,4,4).
wall_num(5,8,0).
wall_num(6,2,2).
wall_num(7,7,1).

light(1,2).
light(1,7).
light(2,1).
light(2,8).
light(3,2).
light(4,4).
light(4,6).
light(5,3).
light(5,5).
light(6,1).
light(6,4).
light(7,2).
light(7,8).
light(8,6).



cell(X,Y):-X>0,X=<8,Y>0,Y=<8.

neighbors(X,Y,X1,Y):-X1 is X+1,cell(X1,Y).
neighbors(X,Y,X1,Y):-X1 is X-1,cell(X1,Y).
neighbors(X,Y,X,Y1):-Y1 is Y+1,cell(X,Y1).
neighbors(X,Y,X,Y1):-Y1 is Y-1,cell(X,Y1).
neighborsAll(X,Y,L):- findall([X1,Y1],neighbors(X,Y,X1,Y1),L).



check_rowA(X,Y,[]):- \+cell(X,Y),!.
check_rowA(X,Y,[]):- wall(X,Y),!.
check_rowA(X,Y,L):- cell(X,Y), \+wall(X,Y),Y1 is Y-1,check_rowA(X,Y1,L1),append([[X,Y]],L1,L).
check_rowB(X,Y,[]):- \+cell(X,Y),!.
check_rowB(X,Y,[]):- wall(X,Y),!.
check_rowB(X,Y,L):- cell(X,Y), \+wall(X,Y),Y1 is Y+1,check_rowB(X,Y1,L1),append([[X,Y]],L1,L).
check_row(X,Y,L):- check_rowA(X,Y,L1),Y1 is Y+1,check_rowB(X,Y1,L2),append(L1,L2,L).

check_colA(X,Y,[]):- \+cell(X,Y),!.
check_colA(X,Y,[]):- wall(X,Y),!.
check_colA(X,Y,L):- cell(X,Y), \+wall(X,Y),X1 is X-1,check_colA(X1,Y,L1),append([[X,Y]],L1,L).
check_colB(X,Y,[]):- \+cell(X,Y),!.
check_colB(X,Y,[]):- wall(X,Y),!.
check_colB(X,Y,L):- cell(X,Y), \+wall(X,Y),X1 is X+1,check_colB(X1,Y,L1),append([[X,Y]],L1,L).
check_col(X,Y,L):- check_colA(X,Y,L1),X1 is X+1,check_colB(X1,Y,L2),append(L1,L2,L).

l_length([], 0).
l_length([_|T], N) :- length(T, N1), N is N1+1.

light_neighbors(X,Y,X1,Y):-X1 is X+1,cell(X1,Y),light(X1,Y).
light_neighbors(X,Y,X1,Y):-X1 is X-1,cell(X1,Y),light(X1,Y).
light_neighbors(X,Y,X,Y1):-Y1 is Y+1,cell(X,Y1),light(X,Y1).
light_neighbors(X,Y,X,Y1):-Y1 is Y-1,cell(X,Y1),light(X,Y1).
light_neighborsAll(X,Y,L):- findall([X1,Y1],light_neighbors(X,Y,X1,Y1),L).


check_wall_neighbors(X,Y):- wall(X,Y),wall_num(X,Y,N),N>=0,N<5 -> light_neighborsAll(X,Y,L),l_length(L,C),C=<N,!;1=1.

light_count([],0):-!.
light_count([H1,H2],0):- not(light(H1,H2)),!.
light_count([H1,H2],1):- light(H1,H2),!.
light_count([H1,H2|T],Count):-light_count(T,Count1),(light(H1,H2)->Count is Count1+1;Count is Count1).


check_lighted_cell(X,Y):- check_row(X,Y,R),flatten(R,Rf),light_count(Rf,C1),check_col(X,Y,Col),flatten(Col,Col1),light_count(Col1,C2), C is C1+C2,C>0.

check_lighted_cell_2(X,Y):- check_row(X,Y,R),flatten(R,Rf),light_count(Rf,C1),check_col(X,Y,Col),flatten(Col,Col1),light_count(Col1,C2), C is C1+C2-1,C>1.

check_all(8,8):-!.
check_all(R,8):- R1 is R+1, R1<9 ,check_all(R1,1),!.
check_all(X,Y):- (wall(X,Y)->Y1 is Y+1,check_all(X,Y1)).
check_all(X,Y):- check_lighted_cell(X,Y), Y1 is Y+1, check_all(X,Y1).

check_double(8,8):-!.
check_double(R,8):- R1 is R+1, R1<9 ,check_double(R1,1),!.
check_double(X,Y):- (wall(X,Y)->Y1 is Y+1,check_double(X,Y1)).
check_double(X,Y):- \+check_lighted_cell_2(X,Y), Y1 is Y+1, check_double(X,Y1).

check_wall(8,8):-!.
check_wall(R,8):- R1 is R+1, R1<9 ,check_wall(R1,1),!.
check_wall(X,Y):- (\+wall(X,Y)->Y1 is Y+1,check_wall(X,Y1)).
check_wall(X,Y):- (wall(X,Y)-> check_wall_neighbors(X,Y),Y1 is
Y+1,check_wall(X,Y1)).

solved:- check_all(1,1),check_double(1,1),check_wall(1,1).
