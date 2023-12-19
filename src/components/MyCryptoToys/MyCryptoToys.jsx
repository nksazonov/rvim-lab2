import React, { useState, useEffect } from "react";
import CryptoToyNFTImage from "../CryptoToyNFTImage/CryptoToyNFTImage";
import MyCryptoToyNFTDetails from "../MyCryptoToyNFTDetails/MyCryptoToyNFTDetails";
import Loading from "../Loading/Loading";

const MyCryptoToys = ({
  accountAddress,
  cryptoToys,
  totalTokensOwnedByAccount,
}) => {
  const [loading, setLoading] = useState(false);
  const [myCryptoToys, setMyCryptoToys] = useState([]);

  useEffect(() => {
    if (cryptoToys.length !== 0) {
      if (cryptoToys[0].metaData !== undefined) {
        setLoading(loading);
      } else {
        setLoading(false);
      }
    }
    const my_crypto_toys = cryptoToys.filter(
      (cryptotoy) => cryptotoy.currentOwner === accountAddress
    );
    setMyCryptoToys(my_crypto_toys);
  }, [cryptoToys]);

  return (
    <div>
      <div className="card mt-1">
        <div className="card-body align-items-center d-flex justify-content-center">
          <h5>
            Total No. of CryptoToy's You Own : {totalTokensOwnedByAccount}
          </h5>
        </div>
      </div>
      <div className="d-flex flex-wrap mb-2">
        {myCryptoToys.map((cryptotoy) => {
          return (
            <div
              key={cryptotoy.tokenId.toNumber()}
              className="w-50 p-4 mt-1 border"
            >
              <div className="row">
                <div className="col-md-6">
                  {!loading ? (
                    <CryptoToyNFTImage
                      colors={
                        cryptotoy.metaData !== undefined
                          ? cryptotoy.metaData.metaData.colors
                          : ""
                      }
                    />
                  ) : (
                    <Loading />
                  )}
                </div>
                <div className="col-md-6 text-center">
                  <MyCryptoToyNFTDetails
                    cryptotoy={cryptotoy}
                    accountAddress={accountAddress}
                  />
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default MyCryptoToys;
