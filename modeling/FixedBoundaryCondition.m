function K=FixedBoundaryCondition(K, dof)
    K(:,dof)=0;
    K(dof,:)=0;
    K(dof,dof)=1;
end