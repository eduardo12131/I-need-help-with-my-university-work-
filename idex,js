let provider;
let signer;
let contract;

// Asegúrate de tener tu ABI aquí
const abi = [
    {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "remitente",
                "type": "address"
            },
            {
                "indexed": true,
                "internalType": "address",
                "name": "destinatario",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "uint256",
                "name": "monto",
                "type": "uint256"
            }
        ],
        "name": "FondosRetenidos",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "remitente",
                "type": "address"
            }
        ],
        "name": "PagoCancelado",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "destinatario",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "uint256",
                "name": "monto",
                "type": "uint256"
            }
        ],
        "name": "PagoLiberado",
        "type": "event"
    },
    {
        "inputs": [],
        "name": "cancelarPago",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "obtenerBalance",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "owner",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "name": "pagos",
        "outputs": [
            {
                "internalType": "address",
                "name": "remitente",
                "type": "address"
            },
            {
                "internalType": "address",
                "name": "destinatario",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "monto",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "tiempoLimite",
                "type": "uint256"
            },
            {
                "internalType": "bool",
                "name": "existe",
                "type": "bool"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_destinatario",
                "type": "address"
            }
        ],
        "name": "realizarPagoEscrow",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "verificarRetencion",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

const contractAddress = "0xDd31952efb18f5934D9a6b9a6ce914b5ec32C5e6"; 

async function init() {
    if (typeof window.ethereum !== 'undefined') {
        provider = new ethers.providers.Web3Provider(window.ethereum);
        await window.ethereum.request({ method: 'eth_requestAccounts' }); // Solicita conexión a MetaMask
        signer = provider.getSigner();
        
        // Inicializa el contrato
        contract = new ethers.Contract(contractAddress, abi, signer);
    } else {
        alert('MetaMask no está instalado. Por favor, instálalo.');
    }
}

async function realizarPago() {
    const destinatario = document.getElementById("destinatario").value;
    const monto = document.getElementById("monto").value;

    if (!destinatario || !monto) {
        alert('Por favor, completa todos los campos.');
        return;
    }

    try {
        const tx = await contract.realizarPagoEscrow(destinatario, { value: ethers.utils.parseEther(monto) });
        await tx.wait();
        alert('Pago realizado con éxito.');

        // Llama a verificarRetencion después de 20 segundos
        setTimeout(async () => {
            await verificarRetencion();
        }, 20000);

    } catch (error) {
        console.error(error);
        alert('Error al realizar el pago.');
    }
}

async function cancelarPago() {
    try {
        const tx = await contract.cancelarPago();
        await tx.wait();
        alert("Pago cancelado con éxito.");
    } catch (error) {
        console.error(error);
        alert("Error al cancelar el pago.");
    }
}

async function verificarRetencion() {
    try {
        const tx = await contract.verificarRetencion();
        await tx.wait();
        alert("Pago liberado automáticamente.");
    } catch (error) {
        console.error(error);
        alert("Error al verificar la retención.");
    }
}

// Inicializa la aplicación
init();
