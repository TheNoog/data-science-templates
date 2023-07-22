function svm = SVM(C, kernel)

    svm.C = C;
    svm.kernel = kernel;
    svm.w = [0, 0];
    svm.b = 0;

end

function svm = fit(svm, X, y, n)

    for i = 1 : n
        score = 0;
        for j = 1 : 2
            score = score + svm.w(j) * X(i, j);
        end
        if y(i) * score + svm.b <= 1
            for j = 1 : 2
                svm.w(j) = svm.w(j) + svm.C * y(i) * X(i, j);
            end
            svm.b = svm.b + svm.C * y(i);
        end
    end

end

function label = predict(svm, X)

    score = 0;
    for j = 1 : 2
        score = score + svm.w(j) * X(j);
    end
    label = (score >= 0) + 1;

end

svm = SVM(1.0, "linear");
svm = fit(svm, array2d(1, 2, [1, 2; 3, 4]), [1, -1], 2);
label = predict(svm, [5, 6]);
disp(label) // prints "1"
