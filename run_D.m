%%%%% Section D %%%%%
% This m file is used to test your code for Section D
% Ensure that when you run this script file
%--- 1.
I = imread('./letter.bmp');
% Continue your code here.

im = edge(I);
imwrite(im,'letter_bm.bmp');

theta = ((-90:89)./180) .* pi; % range of theta
D = sqrt(size(im,1).^2 + size(im,2).^2); % edge image's diagonal
HS = zeros(floor(2.*D),numel(theta)); % accumulator
[y,x] = find(im); % non-zero indices


y = y - 1;
x = x - 1; % MATLAB indices start at 1

rho = zeros(numel(x),numel(theta));
size(rho(1,:))
for i = 1:numel(x)
    rho(i,:) = x(i).*cos(theta) + y(i).*sin(theta);
    rho(i,:) = rho(i,:) + D; % mapping rho from 0 to 2*sqrt(2)
    rho(i,:) = floor(rho(i,:));
    for j = 1:numel(rho(i,:))
        % Increment accumulator
        HS(rho(i,j),j) = HS(rho(i,j),j) + 1;
    end
end

theta_gthreshold=zeros(1, size(im,1)*size(im,2));
rho_gthreshold=zeros(1, size(im,1)*size(im,2));
cnt = 0;

% Image width, x coordinate start and end
x0 = 1;
xend = size(im,2);


threshold = 0.54 * max(HS,[],'all');

figure
imshow(I)
hold on
for i = 1:numel(x)
    for j = 1:numel(rho(i,:))
        if HS(rho(i,j),j) > threshold
            cnt = cnt + 1;   
            theta_gthreshold(cnt) = theta(j);
            rho_gthreshold(cnt)=rho(i,j);

            r = rho(i,j) -D ; th = theta(j); % get rho and theta

            % vertical line
            if (th == 0)
                line([r r], [1 size(im,1)]);
            else
                % Compute y coordinate start
                y0 = (-cos(th)/sin(th))*x0 + (r / sin(th));

                %// Compute y coordinate end
                yend = (-cos(th)/sin(th))*xend + (r / sin(th));

                line([x0 xend], [y0 yend]);
            end
            hold on
        end
    end
end
print('letter_line','-dbmp');

figure
imshow(imadjust(rescale(HS)),'XData',theta,'YData',[0 D],...
      'InitialMagnification','fit');
title('Hough transform of letter.bmp');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);
print('letter_hough','-dbmp');