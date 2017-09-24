function [D] = EdgeDetect(I , s, thetaedge, LaplaceType)
%EDGEDETECT Returns the edges of the given image
    n=ceil(3*s)*2+1;
    Gaussian=fspecial('gaussian', n, s);
    Laplacian=fspecial('log', n, s);


    %% 1.2.2
    Is=imfilter(I,Gaussian,'symmetric');
    L(:,:,1)=imfilter(I,Laplacian,'symmetric');
    %figure;
    %imshow(L(:,:,1),[]);
    %i) Non-Linear Approximation
    B=strel('disk',1);
    L(:,:,2)=imdilate(Is,B)+imerode(Is,B)-2*Is;
    %figure;
    %imshow(L(:,:,2),[]);

    %% 1.2.3

    for K=1:2
        X(:,:,K) = (L(:,:,K) >= 0);
        Y(:,:,K) = imdilate(X(:,:,K),B) - imerode(X(:,:,K),B);
        %figure('Name','Zero crossings');
        %imshow(Y(:,:,K));
        %title('Zero crossings');
    end;

    %% 1.2.4
    [fx,fy]=gradient(Is(:,:));
    gradientIs=sqrt(fx.^2+fy.^2);
    maxofIs=max(max(abs(gradientIs)));
    for K=1:2
        FinalZr(:,:,K) = (Y(:,:,K)==1) & (abs(gradientIs(:,:))>thetaedge*maxofIs);
        %figure('Name','Final Zero crossings');
        %imshow(FinalZr(:,:,K));
        %title('Final Zero crossings');
    end;
    D(:,:) = FinalZr(:,:,LaplaceType+1);


end

