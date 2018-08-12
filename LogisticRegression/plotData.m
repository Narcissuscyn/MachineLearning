function plotData(X)
figure; hold on;
flag=X(:,3);

%can also be implemented using for and if

% Find Indices of Positive and Negative Examples
pos = find(flag == 1); neg = find(flag == 0);
% Plot Examples
plot(X(pos,1),X(pos,2),'K+','LineWidth', 2, 'MarkerSize', 7);
plot(X(neg, 1), X(neg, 2), 'ko', 'MarkerFaceColor', 'y','MarkerSize', 7);