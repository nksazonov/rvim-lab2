import React, { useState, useEffect } from "react";
import CryptoToyNFTImage from "../CryptoToyNFTImage/CryptoToyNFTImage";
import CryptoToyNFTDetails from "../CryptoToyNFTDetails/CryptoToyNFTDetails";
import Loading from "../Loading/Loading";

const AllCryptoToys = ({
  cryptoToys,
  accountAddress,
  totalTokensMinted,
  changeTokenPrice,
  toggleForSale,
  buyCryptoToy,
}) => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (cryptoToys.length !== 0) {
      if (cryptoToys[0].metaData !== undefined) {
        setLoading(loading);
      } else {
        setLoading(false);
      }
    }
  }, [cryptoToys]);

  return (
    <div>
      <div className="card mt-1">
        <div className="card-body align-items-center d-flex justify-content-center">
          <h5>
            Total No. of CryptoToy's Minted On The Platform :{" "}
            {totalTokensMinted}
          </h5>
        </div>
      </div>
      <div className="d-flex flex-wrap mb-2">
        {cryptoToys.map((cryptotoy) => {
          return (
            <div
              key={cryptotoy.tokenId.toNumber()}
              className="w-50 p-4 mt-1 border"
            >
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
              <CryptoToyNFTDetails
                cryptotoy={cryptotoy}
                accountAddress={accountAddress}
                changeTokenPrice={changeTokenPrice}
                toggleForSale={toggleForSale}
                buyCryptoToy={buyCryptoToy}
              />
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default AllCryptoToys;
