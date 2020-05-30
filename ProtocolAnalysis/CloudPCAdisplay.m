%% CloudPCAdisplay is a function that displays 3D scatter plot with overlying PCA vectors

function CloudPCAdisplay(xnd,ynd,znd,coeff,downsampleFactor,Mag,explained,LineWidth)

figure
scatter3(downsample(xnd,downsampleFactor),downsample(ynd,downsampleFactor),...
    downsample(znd,downsampleFactor),'.','MarkerEdgeAlpha',0.7);

hold on
plot3([0,coeff(1,1)]*Mag*explained(1)/100,[0,coeff(2,1)]*Mag*explained(1)/100,[0,coeff(3,1)]*Mag*explained(1)/100,'LineWidth',LineWidth);
plot3([0,coeff(1,2)]*Mag*explained(2)/100,[0,coeff(2,2)]*Mag*explained(2)/100,[0,coeff(3,2)]*Mag*explained(2)/100,'LineWidth',LineWidth);
plot3([0,coeff(1,3)]*Mag*explained(3)/100,[0,coeff(2,3)]*Mag*explained(3)/100,[0,coeff(3,3)]*Mag*explained(3)/100,'LineWidth',LineWidth);
legend('All Data',['PCA1 ',num2str(explained(1)),'% var'],['PCA2 ',num2str(explained(2)),'% var'],['PCA3 ',num2str(explained(3)),'% var'])

title('Acceleration Scatter');
ylabel('y mG');
xlabel('x mG');
zlabel('z mG');