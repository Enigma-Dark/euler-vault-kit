// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Libraries
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Errors} from "../../src/EVault/shared/Errors.sol";

// Test Contracts
import {Invariants} from "./Invariants.t.sol";
import {Setup} from "./Setup.t.sol";

/// @title CryticToFoundry
/// @notice Foundry wrapper for fuzzer failed call sequences
/// @dev Regression testing for failed call sequences
contract CryticToFoundry is Invariants, Setup {
    modifier setup() override {
        _;
        violatorTemp = address(0);
    }

    /// @dev Foundry compatibility faster setup debugging
    function setUp() public {
        // Deploy protocol contracts and protocol actors
        _setUp();

        // Deploy actors
        _setUpActors();

        // Initialize handler contracts
        _setUpHandlers();

        actor = actors[USER1];
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                 BROKEN INVARIANTS REPLAY                                  //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    function test_I_INVARIANT_A() public {
        vm.expectRevert(Errors.E_BadFee.selector);
        this.setInterestFee(101);
        echidna_I_INVARIANT();
    }

    function test_BM_INVARIANT_G() public {
        // PASS
        this.assert_BM_INVARIANT_G();
    }

    function test_BASE_INVARIANT1() public {
        // PASS
        assert_BASE_INVARIANT_B();
    }

    function test_TM_INVARIANT_B() public {
        // PASS
        _setUpBlockAndActor(23863, USER2);
        this.mintToActor(3, 2517);
        _setUpBlockAndActor(77040, USER1);
        this.enableController(115792089237316195423570985008687907853269984665640564039457584007913129639932);
        _setUpBlockAndActor(115661, USER1);
        this.assert_BM_INVARIANT_G();
        echidna_TM_INVARIANT();
    }

    function test_TM_INVARIANT_A2() public {
        // PASS
        _setUpBlockAndActor(24293, USER1);
        this.depositToActor(464, 95416406916653671687163906321353417359071456765389709042486010813678577176823);
        _setUpBlockAndActor(47163, USER2);
        this.enableController(115792089237316195423570889601861022891927484329094684320502060868636724166656);
        _setUpBlockAndActor(47163, USER2);
        this.assert_BM_INVARIANT_G();
        echidna_TM_INVARIANT();
    }

    function test_TM_INVARIANT_B2() public {
        // PASS
        _setUpBlockAndActor(31532, USER3);
        this.mintToActor(134, 38950093316855029701707435728471143612397649181229202547446285813971152397387);
        _setUpBlockAndActor(31532, USER2);
        this.repayWithShares(129, 208);
        echidna_TM_INVARIANT();
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                 BROKEN INVARIANTS REVISION 2                              //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    function test_BASE_INVARIANT2() public {
        // PASS
        _setUpBlockAndActor(25742, USER3);
        this.mintToActor(
            457584007913129639927, 115792089237316195423570985008687907853269984665640564039457584007913129639768
        );
        echidna_BASE_INVARIANT();
    }

    function test_LM_INVARIANT_B() public {
        // PASS
        _setUpBlockAndActor(24253, USER3);
        this.setDebtSocialization(false);
        this.mintToActor(40, 115792089237316195423570985008687907853269984665640564039457584007911240072655);
    }

    function test_BM_INVARIANT6() public {
        // PASS
        this.enableController(468322383632155574862945881956174631649161871295786712111360326257);
        this.setPrice(726828870758264026864714326152620643619927705875320304690180955674, 11);
        this.enableCollateral(15111);
        ////this.setLTV(1, 1, 0);
        this.depositToActor(1, 0);
        this.borrowTo(1, 304818507942225219676445155333052560942359548832832651640621508);
        echidna_BM_INVARIANT();
    }

    function test_echidna_VM_INVARIANT_C1() public {
        vm.skip(true);
        //this.setLTV(1, 1, 0);
        this.mintToActor(2, 0);
        this.setPrice(15141093523755052381928072114906306924899029026721034293540167406168436, 12);
        this.enableController(0);

        console.log("TotalSupply: ", eTST.totalSupply());
        console.log("TotalAssets: ", eTST.totalAssets());

        this.enableCollateral(4565920164825741688803703057878134831253824142353322861254361347742);
        this.borrowTo(1, 0);

        console.log("TotalSupply: ", eTST.totalSupply());
        console.log("TotalAssets: ", eTST.totalAssets());

        console.log("balanceOf: ", eTST.balanceOf(address(actor)));
        console.log("debtOf: ", eTST.debtOf(address(actor)));

        _delay(525);

        console.log("----------");

        console.log("TotalSupply: ", eTST.totalSupply());
        console.log("TotalAssets: ", eTST.totalAssets());

        console.log("balanceOf: ", eTST.balanceOf(address(actor)));
        console.log("debtOf: ", eTST.debtOf(address(actor)));

        console.log("----------");

        this.repayWithShares(2, 0);

        console.log("----------");

        console.log("balanceOf: ", eTST.balanceOf(address(actor)));
        console.log("debtOf: ", eTST.debtOf(address(actor)));

        console.log("TotalSupply: ", eTST.totalSupply());
        console.log("TotalAssets: ", eTST.totalAssets());

        console.log("----------");

        /*         this.loop(2,0);

        console.log("----------");

        console.log("balanceOf: ", eTST.balanceOf(address(actor)));
        console.log("debtOf: ", eTST.debtOf(address(actor)));

        console.log("TotalSupply: ", eTST.totalSupply());
        console.log("TotalAssets: ", eTST.totalAssets());

        console.log("----------");

        this.repayWithShares(3,0);

        console.log("----------");

        console.log("balanceOf: ", eTST.balanceOf(address(actor)));
        console.log("debtOf: ", eTST.debtOf(address(actor)));

        console.log("TotalSupply: ", eTST.totalSupply());
        console.log("TotalAssets: ", eTST.totalAssets());

        console.log("----------"); */

        assert_VM_INVARIANT_C();
    }

    function test_liquidate_bug() public {
        _setUpActorAndDelay(USER3, 297507);
        //this.setLTV(433, 433, 0);
        _setUpActor(USER1);
        this.enableController(1524785991);
        _setUpActorAndDelay(USER1, 439556);
        this.enableCollateral(217905055956562793374063556811130300111285293815122069343455239377127312);
        _setUpActorAndDelay(USER3, 566039);
        this.enableCollateral(29);
        _setUpActorAndDelay(USER3, 209930);
        this.enableController(1524785993);
        _delay(271957);
        this.liquidate(2848675, 0, 512882652);
    }

    function test_VM_INVARIANT5() public {
        //this.setLTV(1, 1, 0);
        this.mintToActor(1, 0);
        this.enableCollateral(0);
        this.setPrice(167287376704962748125159831258059871163051958738722404000304447051, 11);
        this.enableController(0);
        this.borrowTo(1, 0);
        this.repayTo(1, 0);
    }

    function test_borrowing_coverage() public {
        this.depositToActor(100000000000, 0);
        this.depositCollateralToActor(10000000000000000000, 0);
        //this.setLTV(1e4, 1e4, 0);
        this.setPrice(0, 1e18);
        this.setPrice(2, 1e18);
        this.enableController(0);
        this.enableCollateral(0);
        this.borrowTo(1, 318379198685755841947315679159524764739517957049356450836);
    }

    function test_repay_coverage() public {
        _setUpActorAndDelay(USER1, 80932);
        this.withdraw(1524785991, address(789465));
        _setUpActorAndDelay(USER2, 112444);
        this.borrowTo(4369999, 13609915390318032700896377232220083079395853842395211195870658482809261409341);
        _setUpActorAndDelay(USER1, 582191);
        this.repayTo(
            53800299281813669058744869349379135374526250922535558898616928332200178883310,
            62919552230079478689518140392915001440407013600808919191104461459407257746645
        );
        _setUpActorAndDelay(USER2, 440097);
        this.repayTo(4370001, 148);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                         FIX REVISION                                      //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    function test_borrowCoverage() public {
        this.depositToActor(1, 243882164617235048764904608);
        this.enableCollateral(0);
        this.mintCollateralToActor(2, 0);
        this.enableController(1800258655224746867118946383650397);
        this.borrowTo(1, 26044929278355311110009317891546932514);
    }

    function test_repayCoverage() public {
        this.depositToActor(1, 20688509469227803629548472237356323996913977);
        this.enableController(3554832964617168045885851522075051375906075737831533802085648538);
        this.enableCollateral(7486334844696997538320940916429211443676470145365163389407051361);
        this.mintCollateralToActor(2, 1044);
        this.borrowTo(1, 6265957024289727264541187492529679182159257861190152393);
        this.repayTo(1, 0);
    }

    function test_repayWithShareCoverage() public {
        // 1
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 2
        _setUpActorAndDelay(USER2, 172101);
        this.mintToActor(4370000, 13093023029431517515116297493464108021640503049347176947550935870228090307603);

        // 3
        _setUpActorAndDelay(USER3, 463587);
        this.enableCollateral(4370000);

        // 4
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 5
        _setUpActorAndDelay(USER3, 198598);
        this.borrowTo(621, 106369723326817504322082057395634583314815541356617033724546638068337675944543);

        // 6
        _setUpActorAndDelay(USER2, 49735);
        this.mintToActor(1524785993, 4294362097683428896960963005118562901165815780824328019769912464120687011232);

        // 7
        _setUpActorAndDelay(USER1, 526194);
        this.repayWithShares(1524785993, 101789372662970476840627742190011536897514615145941489024870010488433281218895);
    }

    function test_pullDebtCoverage() public {
        // 1
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 2
        _setUpActorAndDelay(USER3, 463587);
        this.enableCollateral(4370000);

        // 3
        _setUpActorAndDelay(USER1, 112444);
        this.enableController(89542571243649197051430772920307087535249499496671593682963902732427039403647);

        // 4
        _setUpActorAndDelay(USER1, 525476);
        this.enableCollateral(115792089237316195423570985008687907853269984665640564039457584007913129639932);

        // 5
        _setUpActorAndDelay(USER2, 400981);
        this.depositToActor(1524785992, 70660979405370551306431037636906474910548328261468048786572907510610053763936);

        // 6
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 7
        _setUpActorAndDelay(USER3, 4177);
        this.setPrice(115518271729930361139946212800867286559642462937563235984193410469727763769722, 4370001);

        // 8
        _setUpActorAndDelay(USER1, 136392);
        this.mintCollateralToActor(1524785991, 4370001);

        // 9
        _setUpActorAndDelay(USER1, 32767);
        this.borrowTo(
            115792089237316195423570985008687907853269984665640564039457584007913129639935,
            115792089237316195423570985008687907853269984665640564039457584007913129639935
        );

        // 10
        _setUpActorAndDelay(USER3, 136394);
        this.pullDebt(4370001, 4370000);
    }

    function test_liquidateCoverage() public {
        // 1
        _setUpActorAndDelay(USER1, 207289);
        this.setAccountOperator(
            105717250746529141172024724297104503287295319057463784682825647261824788845683, 800, true
        );

        // 2
        _setUpActorAndDelay(USER1, 405856);
        this.enableController(17764606878960966821700294425087953767181977824305320974917920152485278716022);

        // 3
        _setUpActorAndDelay(USER3, 439556);
        this.enableCollateral(0);

        // 4
        _setUpActorAndDelay(USER3, 4177);
        this.enableController(96218313369897368400401469462041301000952411458528693032930166145649090196266);

        // 5
        _setUpActorAndDelay(USER3, 439556);
        this.liquidate(4370000, 0, 1524785991);
    }

    function test_liquidateCoverage2() public {
        // 1
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 2
        _setUpActorAndDelay(USER3, 463587);
        this.enableCollateral(4370000);

        // 3
        _setUpActorAndDelay(USER1, 112444);
        this.enableController(89542571243649197051430772920307087535249499496671593682963902732427039403647);

        // 4
        _setUpActorAndDelay(USER1, 525476);
        this.enableCollateral(115792089237316195423570985008687907853269984665640564039457584007913129639932);

        // 5
        _setUpActorAndDelay(USER2, 400981);
        this.depositToActor(1524785992, 70660979405370551306431037636906474910548328261468048786572907510610053763936);

        // 6
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 7
        _setUpActorAndDelay(USER3, 4177);
        this.setPrice(115518271729930361139946212800867286559642462937563235984193410469727763769722, 1e18);

        // 8
        _setUpActorAndDelay(USER3, 198598);
        this.borrowTo(621, 106369723326817504322082057395634583314815541356617033724546638068337675944543);

        // 9
        _setUpActorAndDelay(USER1, 38059);
        this.liquidate(
            type(uint256).max, 67834169209174376432688579979852955112859803843320970887286885013562394664546, 4370000
        );
    }

    function test_withdrawAssertion1() public {
        // 1
        _setUpActorAndDelay(USER2, 414736);
        this.depositToActor(1524785992, 70660979405370551306431037636906474910548328261468048786572907510610053763936);

        // 2
        _setUpActorAndDelay(USER1, 490448);
        this.mintCollateralToActor(4369999, 1524785993);

        // 3
        _setUpActorAndDelay(USER1, 525476);
        this.enableCollateral(115792089237316195423570985008687907853269984665640564039457584007913129639932);

        // 4
        _setUpActorAndDelay(USER3, 521319);
        this.enableCollateral(69322857472681895304938038838156628612468271802824680897342979361702488172834);

        // 5
        _setUpActorAndDelay(USER3, 439556);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 5
        _setUpActorAndDelay(USER1, 439556);
        this.enableController(7571938424744497050025392125255968711315919643451955475186);

        // 6
        _setUpActorAndDelay(USER3, 4177);
        this.setPrice(115518271729930361139946212800867286559642462937563235984193410469727763769722, 4370001);

        // 7
        _setUpActorAndDelay(USER2, 16802);
        this.depositToActor(1524785991, 97);

        //8
        _setUpActorAndDelay(USER3, 94693);
        this.borrowTo(1524785993, 969);

        // 9
        _setUpActorAndDelay(USER2, 400981);
        this.setPrice(
            2918028944904530115677089601774046851350051826784276012161292107035031693773,
            442886312423865560653921465497495729504510949
        );

        // 10
        _setUpActorAndDelay(USER1, 45142);
        this.liquidate(0, 4369999, 4370000);
    }

    function test_liquidationCoverage2() public {
        // 1
        _setUpActorAndDelay(USER3, 463588);
        this.enableCollateral(4370000);

        // 2
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 3
        _setUpActorAndDelay(USER2, 4177);
        this.enableController(43984744813353288885881838083846214633156180114953346776955246789109343466400);

        // 4
        _setUpActorAndDelay(USER1, 447588);
        this.depositToActor(1741670863, 66705428148130105166133477109592350496349947889048187540830930814966397951229);

        // 5
        _setUpActorAndDelay(USER2, 318197);
        this.enableCollateral(4369999);

        // 6
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 7
        _setUpActorAndDelay(USER3, 198598);
        this.borrowTo(621, 106369723326817504322082057395634583314815541356617033724546638068337675944543);

        // 8
        _setUpActorAndDelay(USER1, 38350);
        this.setPrice(4072285750, 3476355193255497328741503339101032877);

        // 9
        _setUpActorAndDelay(USER2, 344203);
        this.liquidate(
            115792089237316195423570985008687907853269984665640564039457584007913129639935,
            1000000000000000000000,
            71058326314738440509394117295321094000732326230855579883183929776326632007787
        );
    }

    function test_liquidationAssertion() public {
        // 1
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 2
        _setUpActorAndDelay(USER3, 401699);
        this.enableCollateral(1524785993);

        // 3
        _setUpActorAndDelay(USER2, 4177);
        this.enableController(43984744813353288885881838083846214633156180114953346776955246789109343466400);

        // 4
        _setUpActorAndDelay(USER1, 447588);
        this.depositToActor(1741670863, 66705428148130105166133477109592350496349947889048187540830930814966397951229);

        // 5
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 6
        _setUpActorAndDelay(USER3, 198598);
        this.borrowTo(621, 106369723326817504322082057395634583314815541356617033724546638068337675944543);

        // 7
        _setUpActorAndDelay(USER2, 344203);
        this.liquidate(
            115792089237316195423570985008687907853269984665640564039457584007913129639935,
            43076252055564096230512111437641469522776970924014296726523799212235104557082,
            71058326314738440509394117295321094000732326230855579883183929776326632007787
        );
    }

    function test_failedAssertion3() public {
        // 1
        _setUpActorAndDelay(USER3, 136392);
        this.donate(4370000, 678);

        // 2
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 3
        _setUpActorAndDelay(USER3, 521319);
        this.enableCollateral(69322857472681895304938038838156628612468271802824680897342979361702488172834);

        // 4
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 5
        _setUpActorAndDelay(USER1, 444463);
        this.skim(4370000, 1524785992);

        // 6
        _setUpActorAndDelay(USER3, 198598);
        this.borrowTo(621, 106369723326817504322082057395634583314815541356617033724546638068337675944543);

        // 7
        _setUpActorAndDelay(USER2, 135921);
        this.enableController(47910244435710312607121944724351163516662496867297591373521936988402150727512);

        // 8
        _setUpActorAndDelay(USER1, 478623);
        this.setPrice(4072285750, 34763553996521932554973228741503339150003228757);
        console.log("Cash.before: ", eTST.cash());
        // 9
        _setUpActorAndDelay(USER2, 344203);
        this.liquidate(
            115792089237316195423570985008687907853269984665640564039457584007913129639935,
            43076252055564096230512111437641469522776970924014296726523799212235104557082,
            71058326314738440509394117295321094000732326230855579883183929776326632007787
        );

        // 10
        _setUpActorAndDelay(USER2, 490448);
        console.log("Totalassets.after: ", eTST.totalAssets());
        this.assert_BM_INVARIANT_G();
    }

    function test_echidna_BM_INVARIANT() public {
        // 1
        _setUpActorAndDelay(USER2, 361136);
        this.depositCollateralToActor(
            115792089237316195423570985008687907853269984665640564039457584007913129639935, 4370000
        );

        // 2
        _setUpActorAndDelay(USER2, 172101);
        this.mintToActor(4370000, 13093023029431517515116297493464108021640503049347176947550935870228090307603);

        // 3
        _setUpActorAndDelay(USER3, 463587);
        this.enableCollateral(4370000);

        // 4
        _setUpActorAndDelay(USER3, 390247);
        this.enableController(7571938424744497050025392125255968711315919643451955475188);

        // 5
        _setUpActorAndDelay(USER3, 198598);
        this.borrowTo(621, 106369723326817504322082057395634583314815541356617033724546638068337675944543);

        // 6
        _setUpActorAndDelay(USER1, 511822);
        this.mintToActor(1524785991, 1524785991);

        // 7
        _setUpActorAndDelay(USER1, 361136);
        this.repayWithShares(611, 1524785993);

        // 8
        _setUpActorAndDelay(USER3, 31594);
        this.depositCollateralToActor(
            4370000, 82219537351169213569972228309424431267756425113427529629224679938600261088229
        );

        // 9
        _setUpActorAndDelay(USER3, 545945);
        this.repayTo(
            30414654813179944674153456741833515114307152122709807632681140684837095933833,
            115792089237316195423570985008687907853269984665640564039457584007913129639935
        );

        console.log(eTST.totalBorrows());

        // 10
        _setUpActorAndDelay(USER3, 434894);
        this.assert_BM_INVARIANT_G();

        console.log(eTST.totalBorrows());

        echidna_BM_INVARIANT();
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                           HELPERS                                         //
    ///////////////////////////////////////////////////////////////////////////////////////////////

    function _setUpBlockAndActor(uint256 _block, address _user) internal {
        vm.roll(_block);
        actor = actors[_user];
    }

    function _delay(uint256 _seconds) internal {
        vm.warp(block.timestamp + _seconds);
    }

    function _setUpActor(address _origin) internal {
        actor = actors[_origin];
    }

    function _setUpActorAndDelay(address _origin, uint256 _seconds) internal {
        actor = actors[_origin];
        vm.warp(block.timestamp + _seconds);
    }

    function _setUpTimestampAndActor(uint256 _timestamp, address _user) internal {
        vm.warp(_timestamp);
        actor = actors[_user];
    }
}
