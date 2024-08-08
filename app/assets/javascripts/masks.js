// Masks
// -----------------------------------

(function() {
  'use strict';

  $(initMasks);

  function initMasks() {

    // CPF
    $('.mask-cpf').inputmask({
      mask: "999.999.999-99",
      removeMaskOnSubmit: true
    });
    // CNPJ
    $('.mask-cnpj').inputmask({
      mask: "99.999.999/9999-99",
      removeMaskOnSubmit: true
    });
    // CEP
    $('.mask-cep').inputmask({
      mask: "99999-999",
      removeMaskOnSubmit: true
    });
    // Vehicle Plate
    $('.mask-vehicle-plate').inputmask({
      mask: "***-****",
      removeMaskOnSubmit: true,
      definitions: {
        '*': {
          validator: "[0-9A-Za-z]",
          casing: "upper"
        }
      }
    });
    $('.mask-letter-chassi').inputmask({
      regex: "[a-zA-Z ]"
    });
    // Date
    $('.mask-date').inputmask({
      alias: 'datetime', inputFormat: "dd/mm/yyyy"
    });
    // Cell Phone
    $('.mask-cellphone').inputmask({
      mask: '(99) 99999-9999'
    });
    // Phone
    $('.mask-phone').inputmask({
      mask: '(99) 9999-9999'
    });
    // CEP
    $('.mask-cep').inputmask({
      mask: '99999-999'
    });
    // Number
    $('.mask-number').inputmask({
      mask: "9",
      repeat: 20
    });
    $('.mask-account').mask('########000-%', {
        placeholder: "0000000-0",
        reverse: true,
        'translation':{'%': {pattern: /[\dPXpx]/, recursive: true}},
        onKeyPress: function (v, e){e.target.value = v.toUpperCase(); e.target.maxLength = e.target.size = 13;}
    });

    // Title
    $('.mask-title').inputmask({
      regex: "[a-zA-Z0-9]",
      repeat: 10,
      placeholder: ""
    });
    // Month and Year
    $('.mask-month-year').inputmask({
      mask: '99/9999'
    });
    // Currency
    $('.mask-currency').inputmask( 'currency',{
        autoUnmask: true,
        radixPoint:",",
        groupSeparator: ".",
        allowMinus: true,
        prefix: 'R$ ',
        digits: 2,
        digitsOptional: false,
        rightAlign: false,
        placeholder: '0,00',
        unmaskAsNumber: true,
        removeMaskOnSubmit: true,
    });
  }
})();