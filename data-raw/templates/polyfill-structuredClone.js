if(!global.structuredClone){
    global.structuredClone = function structuredClone(objectToClone) {
          const stringified = JSON.stringify(objectToClone);
          const parsed = JSON.parse(stringified);
          return parsed;
        }
}
