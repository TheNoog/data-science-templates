program LassoRegression

    ! Define the number of samples and features
    integer, parameter :: N_SAMPLES = 100
    integer, parameter :: N_FEATURES = 20

    ! Function to calculate the mean squared error
    real(kind=8) function calculateMeanSquaredError(yTrue, yPred)
        real(kind=8), dimension(:) :: yTrue, yPred
        integer :: n
        n = size(yTrue)
        calculateMeanSquaredError = sum((yTrue - yPred)**2) / real(n, kind=8)
    end function calculateMeanSquaredError

    ! Function to perform LASSO regression
    subroutine lassoRegression(X, y, coefficients, alpha)
        real(kind=8), dimension(:,:) :: X
        real(kind=8), dimension(:) :: y, coefficients
        real(kind=8) :: alpha
        ! Maximum number of iterations for coordinate descent
        integer, parameter :: maxIterations = 100
        
        ! Step size for coordinate descent
        real(kind=8), parameter :: stepSize = 0.01

        integer :: nSamples, nFeatures, i, j, k
        real(kind=8) :: gradient, pred

        nSamples = size(X, 1)
        nFeatures = size(X, 2)

        ! Initialize the coefficients to zero
        coefficients = 0.0

        ! Perform coordinate descent
        do iteration = 1, maxIterations
            do j = 1, nFeatures
                ! Calculate the gradient for feature j
                gradient = 0.0
                do i = 1, nSamples
                    pred = 0.0
                    do k = 1, nFeatures
                        if (k /= j) then
                            pred = pred + X(i, k) * coefficients(k)
                        end if
                    end do
                    gradient = gradient + (y(i) - pred) * X(i, j)
                end do

                ! Update the coefficient using LASSO penalty
                if (gradient > alpha) then
                    coefficients(j) = (gradient - alpha) * stepSize
                else if (gradient < -alpha) then
                    coefficients(j) = (gradient + alpha) * stepSize
                else
                    coefficients(j) = 0.0
                end if
            end do
        end do
    end subroutine lassoRegression

    ! Generate some synthetic data
    subroutine generateSyntheticData(X, y)
        real(kind=8), dimension(:,:) :: X
        real(kind=8), dimension(:) :: y
        real(kind=8) :: rngSeed
        integer :: i, j
        ! Use a random seed for reproducibility
        rngSeed = 42.0
        call random_seed(size = seedSize)
        allocate(seed(seedSize))
        seed = 0
        seed(1) = rngSeed
        call random_seed(put = seed)

        do i = 1, N_SAMPLES
            do j = 1, N_FEATURES
                call random_number(X(i, j))
            end do
            y(i) = 0.0
            do j = 1, N_FEATURES
                y(i) = y(i) + X(i, j) * real(j, kind=8)
            end do
            y(i) = y(i) + 0.1 * random_number()
        end do
    end subroutine generateSyntheticData

    ! Main program
    program main
        real(kind=8), dimension(N_SAMPLES, N_FEATURES) :: X
        real(kind=8), dimension(N_SAMPLES) :: y, coefficients
        real(kind=8) :: alpha, mse
        integer :: nTrainSamples, nTestSamples, i, j

        ! Generate some synthetic data
        call generateSyntheticData(X, y)

        ! Split the data into training and test sets
        nTrainSamples = NINT(N_SAMPLES * 0.8)
        nTestSamples = N_SAMPLES - nTrainSamples
        real(kind=8), dimension(nTrainSamples, N_FEATURES) :: XTrain
        real(kind=8), dimension(nTrainSamples) :: yTrain
        real(kind=8), dimension(nTestSamples, N_FEATURES) :: XTest
        real(kind=8), dimension(nTestSamples) :: yTest

        do i = 1, nTrainSamples
            XTrain(i, :) = X(i, :)
            yTrain(i) = y(i)
        end do
        do i = nTrainSamples + 1, N_SAMPLES
            XTest(i - nTrainSamples, :) = X(i, :)
            yTest(i - nTrainSamples) = y(i)
        end do

        ! Perform LASSO regression
        alpha = 0.1
        coefficients = 0.0
        call lassoRegression(XTrain, yTrain, coefficients, alpha)

        ! Make predictions on the test set
        real(kind=8), dimension(nTestSamples) :: yPred
        do i = 1, nTestSamples
            yPred(i) = sum(XTest(i, :) * coefficients)
        end do

        ! Calculate the mean squared error
        mse = calculateMeanSquaredError(yTest, yPred)
        print *, "Mean Squared Error:", mse

        ! Print the true coefficients and the estimated coefficients
        print *, "True Coefficients: [1.0", (/(real(j, kind=8), j=2,N_FEATURES)/), "]"
        print *, "Estimated Coefficients:", coefficients
    end program main
end program LassoRegression
