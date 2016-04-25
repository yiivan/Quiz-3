var isEven = function (x) { return x % 2 == 0; };

var filter = function(num, func) {
	num2 = [];
  for ( var i=0; i<num.length; i++ ) {
    if (func(num[i])) {
  	   num2.push(num[i]);
    }
  }
	console.log(num2);
};


filter([1, 2, 3, 4], isEven); // => [2, 4]
