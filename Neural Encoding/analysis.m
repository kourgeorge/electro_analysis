
figure;
hold on;
for i=1:length(x)
    disp([num2str(x(i)), ' ', num2str(y(i))]);
    scatter(x(i), y(i))
    pause(0.01)
    
end