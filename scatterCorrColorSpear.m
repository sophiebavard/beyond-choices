function [ RHO PVAL b stats ] = scatterCorrColorSpear( X, Y, stat,text1, markersize, Color)


%Scatter Plot + corr (coef + pValue)

% Corr
[RHO,PVAL] = corr(X,Y,'type','spearman');


% Text variable
if stat==1
    test=['rho= ' num2str(RHO) ' / p= ' num2str(PVAL)];
elseif stat==2
    % RobustFit
    [b,stats] = robustfit(X, Y);
    test=['RobustFit pval= ' num2str(stats.p(2,1))];
else
    test=['no test performed']
end


% Scatter
scatter(X, Y, markersize,'filled','MarkerFaceColor',Color);
% title(Title,...
%     'FontSize',12)


P = polyfit(X,Y,1);
Yf = polyval(P,X);
hold on
plot(X,Yf,'k');
% Text position
xPoint=xlim;
yPoint=ylim;
x=(xPoint(1,1)+xPoint(1,2))/3;
y=(yPoint(1,1)+yPoint(1,2))/2;
%x=.75;
%y=.75;
if text1
    hl = legend('Location','best');
    pos = hl.Position;
    txtx = pos(1);
    txty = pos(2);
    delete(hl)
    text(txtx,txty,test,'BackgroundColor',[1 1 1],'FontSize',9);
end
% ylim([min(Y) max(Y)]);
% xlim([min(X) max(X)]);


% 
% 
% 
% %Scatter Plot + corr (coef + pValue)
% 
% % % Corr
% % [RHO,PVAL] = corr(X,Y);
% % 
% % % RobustFit
% % [b,stats] = robustfit(X, Y);
% % 
% % % Text variable
% % if stat==1
% %     test=['coef= ' num2str(RHO) ' / P= ' num2str(PVAL)];
% % elseif stat==2
% %     test=['RobustFit pval= ' num2str(stats.p(2,1))];
% % else
% %     test=['no test performed']
% % end
% 
% % Scatter
% scatter(X, Y,...
%     'MarkerFaceColor',Color,...
%     'MarkerEdgeColor',Color,...
%     'LineWidth',line)
% % title(Title,...
% %     'FontSize',12)
% 
% P = polyfit(X,Y,1);
% Yf = polyval(P,X);
% hold on
% plot(X,Yf,...
%     'LineWidth',2,...
%     'Color',[0 0 0]);
% % Text position
% xPoint=xlim;
% yPoint=ylim;
% 
% 
% hold on
% plot([-1 1],[-1 1],...
%     'LineStyle',':',...
%     'LineWidth',1,...
%     'Color',[0 0 0]);
% 
% 
% % x=(xPoint(1,1)+xPoint(1,2))/2;
% % y=(yPoint(1,1)+yPoint(1,2))/2;
% % x=(xPoint(1,1)+xPoint(1,2))/2;
% % y=(yPoint(1,2));
% % text(x,y,test,'BackgroundColor',[1 1 1],...
% %     'FontSize',12);
% set(gca,'FontSize',12)
% % ylim([min(Y) max(Y)]);
% % xlim([min(X) max(X)]);
end