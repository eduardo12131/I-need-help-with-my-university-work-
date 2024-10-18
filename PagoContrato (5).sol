// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract PagoContrato {
    address public owner;

    // Estructura para almacenar información de cada pago
    struct Pago {
        address remitente;
        address destinatario;
        uint256 monto;
        uint256 tiempoLimite;
        bool existe; // Para verificar si el pago existe
    }

    // Mapeo para almacenar los pagos por dirección del remitente
    mapping(address => Pago) public pagos;

    event FondosRetenidos(address indexed remitente, address indexed destinatario, uint256 monto);
    event PagoLiberado(address indexed destinatario, uint256 monto);
    event PagoCancelado(address indexed remitente);

    constructor() {
        owner = msg.sender; // El propietario del contrato es quien lo despliega
    }

    // Función para realizar pagos con escrow y establecer un tiempo límite de 20 segundos
    function realizarPagoEscrow(address _destinatario) public payable {
        require(msg.value > 0, "El monto debe ser mayor a cero");
        require(_destinatario != address(0), "La direccion del destinatario no puede ser cero");
        require(!pagos[msg.sender].existe, "Ya hay un pago pendiente para este remitente"); // Verificamos si ya hay un pago

        // Guardar el pago en el mapeo
        pagos[msg.sender] = Pago(msg.sender, _destinatario, msg.value, block.timestamp + 20 seconds, true);
        emit FondosRetenidos(msg.sender, _destinatario, msg.value);
    }

    // Verificar si se debe liberar el pago automáticamente al llegar el tiempo límite
    function verificarRetencion() public {
        Pago storage pago = pagos[msg.sender]; // Obtén el pago del remitente
        require(pago.existe, "No hay un pago pendiente");
        require(block.timestamp >= pago.tiempoLimite, "No se ha alcanzado el tiempo limite");
        require(pago.monto > 0, "No hay fondos para liberar");

        // Realizar el pago automáticamente al destinatario
        uint256 monto = pago.monto;
        pago.monto = 0; // Prevenir reentradas
        payable(pago.destinatario).transfer(monto);
        emit PagoLiberado(pago.destinatario, monto);

        // Resetear el estado del pago
        delete pagos[msg.sender]; // Eliminar el pago del mapeo
    }

    // Cancelar el pago antes de que se envíe automáticamente
    function cancelarPago() public {
        Pago storage pago = pagos[msg.sender];
        require(pago.existe, "No hay un pago pendiente");

        // Devolver el monto al remitente
        uint256 monto = pago.monto;
        require(monto > 0, "No hay fondos para cancelar");

        pago.monto = 0; // Prevenir reentradas
        delete pagos[msg.sender]; // Eliminar el pago del mapeo
        payable(msg.sender).transfer(monto); // Devolver el monto al remitente

        emit PagoCancelado(msg.sender);
    }

    // Obtener el balance actual del contrato
    function obtenerBalance() public view returns (uint256) {
        return address(this).balance; // Retorna el balance del contrato
    }
}

