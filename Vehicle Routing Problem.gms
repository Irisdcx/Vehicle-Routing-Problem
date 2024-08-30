Sets
  i 'cities'    /i1*i10/
  k 'vehicles'  /k1*k5/
  ij(i,i) 'city pairs'
;

Alias(i,j,jj);

ij(i,j) = yes$(ord(i) <> ord(j));

Scalars
max_capacity 'maximum capacity' /35/
base_transportation_cost 'base transportation cost' /50/
overtime_cost 'overtime cost' /100/
;

Parameters
  demand(i) 'demand for each city'
  /i1 15, i2 1, i3 8, i4 14, i5 4, i6 14, i7 12, i8 16, i9 15, i10 11/
;

parameter work_time(i,j) 'work time between cities'
  / i1.i2  6.19, i1.i3  5.74, i1.i4  5.45, i1.i5  5.78, i1.i6  0.44, i1.i7  3.38, i1.i8  0.41, i1.i9  0.33, i1.i10 1.77
    i2.i1  6.19, i2.i3  1.36, i2.i4  0.79, i2.i5  0.26, i2.i6  6.39, i2.i7  2.96, i2.i8  6.39, i2.i9  6.02, i2.i10 8.03
    i3.i1  5.74, i3.i2  1.36, i3.i4  1.96, i3.i5  1.31, i3.i6  6.44, i3.i7  2.73, i3.i8  6.46, i3.i9  6.1,  i3.i10 8.09
    i4.i1  5.45, i4.i2  0.79, i4.i3  1.96, i4.i5  0.69, i4.i6  5.69, i4.i7  2.47, i4.i8  5.33, i4.i9  5.0,  i4.i10 6.75
    i5.i1  5.78, i5.i2  0.26, i5.i3  1.31, i5.i4  0.69, i5.i6  6.16, i5.i7  2.79, i5.i8  6.17, i5.i9  5.8,  i5.i10 7.75
    i6.i1  0.44, i6.i2  6.39, i6.i3  6.44, i6.i4  5.69, i6.i5  6.16, i6.i7  3.77, i6.i8  0.44, i6.i9  0.62, i6.i10 1.42
    i7.i1  3.38, i7.i2  2.96, i7.i3  2.73, i7.i4  2.47, i7.i5  2.79, i7.i6  3.77, i7.i8  3.77, i7.i9  3.43, i7.i10 5.15
    i8.i1  0.41, i8.i2  6.39, i8.i3  6.46, i8.i4  5.33, i8.i5  6.17, i8.i6  0.44, i8.i7  3.77, i8.i9  0.49, i8.i10 1.63
    i9.i1  0.33, i9.i2  6.02, i9.i3  6.1,  i9.i4  5.0,  i9.i5  5.8,  i9.i6  0.62, i9.i7  3.43, i9.i8  0.49, i9.i10 1.96
    i10.i1 1.77, i10.i2 8.03, i10.i3 8.09, i10.i4 6.75, i10.i5 7.75, i10.i6 1.42, i10.i7 5.15, i10.i8 1.63, i10.i9 1.96
/;

parameter
max_working_hours(k)
/k1   8
k2    8
k3    8
k4    8
k5    8
/;

Binary Variables
x(i,j,k) 'binary decision variable for routes'
y(i,j,k) 'binary decision variable for connected routes'
;

Variables
obj  'objective function'
z(i,k) 'binary decision variable for required cities';

Equations
objective 'objective function'
demand_constraint(i) 'demand constraint for each city'
capacity_constraint(k) 'capacity constraint for each vehicle'
no_self_route(i,k) 'constraint for no self-route'
at_least_one_route(i) 'constraint to ensure each city is visited at least once'
continuous_route(i,k) 'The route continuity constraint for each vehicle'
;

objective ..
obj =e= sum((i,j,k)$(ord(i) <> ord(j)),
    work_time(i,j) * x(i,j,k) * base_transportation_cost
    + max(0, work_time(i,j) - max_working_hours(k)) * x(i,j,k) * overtime_cost
  );

demand_constraint(i) ..
sum( (j,k)$((ord(j) <> ord(i))),x(i,j,k) )
  =E= sum( (jj,k)$((ord(jj) <> ord(i))),x(jj,i,k) );
  
continuous_route(i,k)$(ord(i) <> ord(k))..
    sum(j, y(i,j,k) - y(j,i,k) + x(i,j,k) - x(j,i,k)) =E= sum(j, y(i,j,k)) - sum(j, y(j,i,k));


no_self_route(i,k)$(ord(i) = ord(k))..
    x(i, i, k) =e= 0;

at_least_one_route(i)..
    sum(k, sum(j$(ord(j)<>ord(i)), x(i,j,k))) =G= 1;


capacity_constraint(k) ..
sum( (i, j)$(ord(i) <> ord(j)),
    demand(i) * x(i,j,k) ) =L= max_capacity;
    

Model DeliveryOptimization /all/;

Solve DeliveryOptimization using MIP minimizing obj;

Display obj.L, x.L, x.M;
