//  void main(){


//    num evaluate(str) {
//   List<dynamic> splitStringArithmetic(String str) {
//     int index = 0;
//     var splitArray = str.split("").reduce((arr, v, i) {
//       if (num.tryParse(v)) {
//         arr.add(str.slice(index, i));
//         arr.add(v);
//         index = i + 1;
//       }
//       return arr;
//     }, []);
//     splitArray.push(str.slice(index));
//     return splitArray;
//   }

//   function findOperator(arr, o) {
//     return arr.findIndex(i => i == o);
//   }

//   function arithmetic(o, a, b) {
//     var arithmeticObject = {
//       "*": a * b,
//       "/": a / b,
//       "+": a + b,
//       "-": a - b
//     };
//     return arithmeticObject[o];
//   }

//   function compute(arr, o) {
//     var index = findOperator(arr, o);
//     arr[index] = arithmetic(o, arr[index - 1], arr[index + 1]);
//     return arr.filter((c, i) => {
//       return i !== index - 1 && i !== index + 1;
//     });
//   }
//   function containsOperators(arr) {
//     return arr.some(i => i === "*" || i === "/" || i === "+" || i === "-");
//   }

//   function simplify(arr) {
//     while (containsOperators(arr)) {
//       if (arr.includes("*") && arr.includes("/")) {
//         if (findOperator(arr, "/") < findOperator(arr, "*")) {
//           arr = compute(arr, "/");
//         } else {
//           arr = compute(arr, "*");
//         }
//       } else if (arr.includes("*")) {
//         arr = compute(arr, "*");
//       } else if (arr.includes("/")) {
//         arr = compute(arr, "/");
//       } else if (arr.includes("+") && arr.includes("-")) {
//         if (findOperator(arr, "-") < findOperator(arr, "+")) {
//           arr = compute(arr, "-");
//         } else {
//           arr = compute(arr, "+");
//         }
//       } else if (arr.includes("+")) {
//         arr = compute(arr, "+");
//       } else {
//         arr = compute(arr, "-");
//       }
//     }
//     return arr;
//   }

//   var arithmeticArray = splitStringArithmetic(str);
//   return parseInt(simplify(arithmeticArray));
// }

// var str = "10*10/10+5*10-10";
// console.log(evaluate(str));


//  }



// ///////
// ///
// ///