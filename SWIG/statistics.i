
/*
 Copyright (C) 2000, 2001, 2002 RiskMap srl

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it under the
 terms of the QuantLib license.  You should have received a copy of the
 license along with this program; if not, please email ferdinando@ametrano.net
 The license is also available online at http://quantlib.org/html/license.html

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

// $Id$

#ifndef quantlib_statistics_i
#define quantlib_statistics_i

%include types.i
%include linearalgebra.i
%include vectors.i
%include stl.i

%{
using QuantLib::Math::Statistics;
%}

#if defined(SWIGRUBY)
%rename("reset!")                Statistics::reset;
#elif defined(SWIGMZSCHEME) || defined(SWIGGUILE)
%rename("weight-sum")            Statistics::weightSum;
%rename("standard-deviation")    Statistics::standardDeviation;
%rename("downside-variance")     Statistics::downsideVariance;
%rename("downside-deviation")    Statistics::downsideDeviation;
%rename("error-estimate")        Statistics::errorEstimate;
%rename("reset!")                Statistics::reset;
#endif

#if defined(SWIGMZSCHEME) || defined(SWIGGUILE)
// resolve overloading
%rename("add_single")             Statistics::add(double,double);
%rename("add_sequence")           Statistics::add(const std::vector<double>&);
%rename("add_weighted_sequence")  Statistics::add(const std::vector<double>&,
                                                  const std::vector<double>&);
#if defined(SWIGGUILE)
%scheme %{
    (define (Statistics-add stats value . weight)
      (let ((method (cond ((number? value) Statistics-add-single)
                          ((null? weight) Statistics-add-sequence)
                          (else Statistics-add-weighted-sequence))))
        (apply method stats value weight)))
    (export Statistics-add)
%}
#endif
#endif

class Statistics {
  public:
    Size samples() const;
    double weightSum() const;
    double mean() const;
    double variance() const;
    double standardDeviation() const;
    double downsideVariance() const;
    double downsideDeviation() const;
    double errorEstimate() const;
    double skewness() const;
    double kurtosis() const;
    double min() const;
    double max() const;
    // Modifiers
    void add(double value, double weight = 1.0);
    void reset();
};

%extend Statistics {
    void add(const std::vector<double>& values) {
        self->addSequence(values.begin(), values.end());
    }
    void add(const std::vector<double>& values, 
             const std::vector<double>& weights) {
        self->addSequence(values.begin(), values.end(), weights.begin());
    }
}


%{
using QuantLib::Math::MultivariateAccumulator;
%}

class MultivariateAccumulator {
  public:
    Size size() const;
    Size samples() const;
    double weightSum() const;
    Array mean() const;
    Matrix covariance() const;
	Matrix correlation() const;
    void add(const Array& a, double weight = 1.0);
    void reset();
};


#endif