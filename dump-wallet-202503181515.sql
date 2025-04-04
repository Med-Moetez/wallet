PGDMP  %                    }            wallet    17.2    17.0 5    $           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            %           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            &           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            '           1262    16389    wallet    DATABASE     y   CREATE DATABASE wallet WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'French_France.1252';
    DROP DATABASE wallet;
                     postgres    false                        2615    131531    postgraphile_watch    SCHEMA     "   CREATE SCHEMA postgraphile_watch;
     DROP SCHEMA postgraphile_watch;
                     postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            (           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    7            )           0    0    SCHEMA public    ACL     �   GRANT ALL ON SCHEMA public TO anon;
GRANT ALL ON SCHEMA public TO reg_user;
GRANT ALL ON SCHEMA public TO super_admin;
GRANT ALL ON SCHEMA public TO postgres;
                        pg_database_owner    false    7            �           1247    24578    Typetransaction    TYPE     N   CREATE TYPE public."Typetransaction" AS ENUM (
    'income',
    'expense'
);
 $   DROP TYPE public."Typetransaction";
       public               postgres    false    7            }           1247    16391 
   UserGender    TYPE     F   CREATE TYPE public."UserGender" AS ENUM (
    'Male',
    'Female'
);
    DROP TYPE public."UserGender";
       public               postgres    false    7            �           1247    40992 	   jwt_token    TYPE     I   CREATE TYPE public.jwt_token AS (
	role text,
	exp integer,
	sub text
);
    DROP TYPE public.jwt_token;
       public               postgres    false    7                       1255    131532    notify_watchers_ddl()    FUNCTION     �  CREATE FUNCTION postgraphile_watch.notify_watchers_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'ddl',
      'payload',
      (select json_agg(json_build_object('schema', schema_name, 'command', command_tag)) from pg_event_trigger_ddl_commands() as x)
    )::text
  );
end;
$$;
 8   DROP FUNCTION postgraphile_watch.notify_watchers_ddl();
       postgraphile_watch               postgres    false    6                       1255    131533    notify_watchers_drop()    FUNCTION     _  CREATE FUNCTION postgraphile_watch.notify_watchers_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'drop',
      'payload',
      (select json_agg(distinct x.schema_name) from pg_event_trigger_dropped_objects() as x)
    )::text
  );
end;
$$;
 9   DROP FUNCTION postgraphile_watch.notify_watchers_drop();
       postgraphile_watch               postgres    false    6            �            1259    24597    Budget    TABLE     �   CREATE TABLE public."Budget" (
    budget_id text NOT NULL,
    user_id text,
    category_id text,
    amount double precision,
    month timestamp(3) without time zone,
    alert_threshold integer
);
    DROP TABLE public."Budget";
       public         heap r       postgres    false    7            *           0    0    TABLE "Budget"    ACL     `   GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public."Budget" TO anon;
          public               postgres    false    223            �            1259    24583    Category    TABLE     Q   CREATE TABLE public."Category" (
    id text NOT NULL,
    name text NOT NULL
);
    DROP TABLE public."Category";
       public         heap r       postgres    false    7            +           0    0    TABLE "Category"    ACL     b   GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public."Category" TO anon;
          public               postgres    false    221            �            1259    131372    OtpVerification    TABLE       CREATE TABLE public."OtpVerification" (
    id text NOT NULL,
    user_id text NOT NULL,
    otp text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email text
);
 %   DROP TABLE public."OtpVerification";
       public         heap r       postgres    false    7            �            1259    24604    Report    TABLE     y   CREATE TABLE public."Report" (
    report_id text NOT NULL,
    user_id text,
    created_at text,
    file_path text
);
    DROP TABLE public."Report";
       public         heap r       postgres    false    7            ,           0    0    TABLE "Report"    ACL     `   GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public."Report" TO anon;
          public               postgres    false    224            �            1259    24590    Transaction    TABLE     -  CREATE TABLE public."Transaction" (
    transaction_id text NOT NULL,
    user_id text,
    category_id text,
    amount double precision NOT NULL,
    date timestamp(3) without time zone,
    description text,
    type public."Typetransaction" DEFAULT 'expense'::public."Typetransaction" NOT NULL
);
 !   DROP TABLE public."Transaction";
       public         heap r       postgres    false    902    902    7            -           0    0    TABLE "Transaction"    ACL     e   GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public."Transaction" TO anon;
          public               postgres    false    222            �            1259    16411    User    TABLE     �   CREATE TABLE public."User" (
    "oidcId" text NOT NULL,
    "firstName" text,
    "lastName" text,
    gender public."UserGender",
    email text,
    tel text,
    picture text,
    password text,
    date timestamp(3) without time zone
);
    DROP TABLE public."User";
       public         heap r       postgres    false    7    893            .           0    0    TABLE "User"    ACL     �   GRANT ALL ON TABLE public."User" TO reg_user;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public."User" TO anon;
          public               postgres    false    219            �            1259    16418 
   UserDevice    TABLE     h   CREATE TABLE public."UserDevice" (
    "userId" text NOT NULL,
    token text NOT NULL,
    ua jsonb
);
     DROP TABLE public."UserDevice";
       public         heap r       postgres    false    7                      0    24597    Budget 
   TABLE DATA           c   COPY public."Budget" (budget_id, user_id, category_id, amount, month, alert_threshold) FROM stdin;
    public               postgres    false    223   �@                 0    24583    Category 
   TABLE DATA           .   COPY public."Category" (id, name) FROM stdin;
    public               postgres    false    221   �@       !          0    131372    OtpVerification 
   TABLE DATA           ^   COPY public."OtpVerification" (id, user_id, otp, "expiresAt", "createdAt", email) FROM stdin;
    public               postgres    false    226   WC                  0    24604    Report 
   TABLE DATA           M   COPY public."Report" (report_id, user_id, created_at, file_path) FROM stdin;
    public               postgres    false    224   tC                 0    24590    Transaction 
   TABLE DATA           n   COPY public."Transaction" (transaction_id, user_id, category_id, amount, date, description, type) FROM stdin;
    public               postgres    false    222   �C                 0    16411    User 
   TABLE DATA           p   COPY public."User" ("oidcId", "firstName", "lastName", gender, email, tel, picture, password, date) FROM stdin;
    public               postgres    false    219   G                 0    16418 
   UserDevice 
   TABLE DATA           ;   COPY public."UserDevice" ("userId", token, ua) FROM stdin;
    public               postgres    false    220   �H       |           2606    24603    Budget Budget_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."Budget"
    ADD CONSTRAINT "Budget_pkey" PRIMARY KEY (budget_id);
 @   ALTER TABLE ONLY public."Budget" DROP CONSTRAINT "Budget_pkey";
       public                 postgres    false    223            v           2606    24589    Category Category_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."Category" DROP CONSTRAINT "Category_pkey";
       public                 postgres    false    221            �           2606    131379 $   OtpVerification OtpVerification_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."OtpVerification"
    ADD CONSTRAINT "OtpVerification_pkey" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public."OtpVerification" DROP CONSTRAINT "OtpVerification_pkey";
       public                 postgres    false    226            ~           2606    24610    Report Report_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_pkey" PRIMARY KEY (report_id);
 @   ALTER TABLE ONLY public."Report" DROP CONSTRAINT "Report_pkey";
       public                 postgres    false    224            x           2606    24596    Transaction Transaction_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_pkey" PRIMARY KEY (transaction_id);
 J   ALTER TABLE ONLY public."Transaction" DROP CONSTRAINT "Transaction_pkey";
       public                 postgres    false    222            r           2606    16424    UserDevice UserDevice_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public."UserDevice"
    ADD CONSTRAINT "UserDevice_pkey" PRIMARY KEY ("userId", token);
 H   ALTER TABLE ONLY public."UserDevice" DROP CONSTRAINT "UserDevice_pkey";
       public                 postgres    false    220    220            p           2606    16417    User User_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY ("oidcId");
 <   ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
       public                 postgres    false    219            z           1259    24613    Budget_budget_id_key    INDEX     W   CREATE UNIQUE INDEX "Budget_budget_id_key" ON public."Budget" USING btree (budget_id);
 *   DROP INDEX public."Budget_budget_id_key";
       public                 postgres    false    223            t           1259    24611    Category_id_key    INDEX     M   CREATE UNIQUE INDEX "Category_id_key" ON public."Category" USING btree (id);
 %   DROP INDEX public."Category_id_key";
       public                 postgres    false    221            �           1259    131385    OtpVerification_user_id_idx    INDEX     ^   CREATE INDEX "OtpVerification_user_id_idx" ON public."OtpVerification" USING btree (user_id);
 1   DROP INDEX public."OtpVerification_user_id_idx";
       public                 postgres    false    226                       1259    24614    Report_report_id_key    INDEX     W   CREATE UNIQUE INDEX "Report_report_id_key" ON public."Report" USING btree (report_id);
 *   DROP INDEX public."Report_report_id_key";
       public                 postgres    false    224            y           1259    24612    Transaction_transaction_id_key    INDEX     k   CREATE UNIQUE INDEX "Transaction_transaction_id_key" ON public."Transaction" USING btree (transaction_id);
 4   DROP INDEX public."Transaction_transaction_id_key";
       public                 postgres    false    222            s           1259    16473    UserDevice_token_key    INDEX     W   CREATE UNIQUE INDEX "UserDevice_token_key" ON public."UserDevice" USING btree (token);
 *   DROP INDEX public."UserDevice_token_key";
       public                 postgres    false    220            n           1259    16472    User_oidcId_key    INDEX     O   CREATE UNIQUE INDEX "User_oidcId_key" ON public."User" USING btree ("oidcId");
 %   DROP INDEX public."User_oidcId_key";
       public                 postgres    false    219            �           2606    24630    Budget Budget_category_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Budget"
    ADD CONSTRAINT "Budget_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 L   ALTER TABLE ONLY public."Budget" DROP CONSTRAINT "Budget_category_id_fkey";
       public               postgres    false    221    4726    223            �           2606    24625    Budget Budget_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Budget"
    ADD CONSTRAINT "Budget_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"("oidcId") ON UPDATE CASCADE ON DELETE SET NULL;
 H   ALTER TABLE ONLY public."Budget" DROP CONSTRAINT "Budget_user_id_fkey";
       public               postgres    false    4720    219    223            �           2606    131380 ,   OtpVerification OtpVerification_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."OtpVerification"
    ADD CONSTRAINT "OtpVerification_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"("oidcId") ON UPDATE CASCADE ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public."OtpVerification" DROP CONSTRAINT "OtpVerification_user_id_fkey";
       public               postgres    false    4720    226    219            �           2606    24635    Report Report_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Report"
    ADD CONSTRAINT "Report_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"("oidcId") ON UPDATE CASCADE ON DELETE SET NULL;
 H   ALTER TABLE ONLY public."Report" DROP CONSTRAINT "Report_user_id_fkey";
       public               postgres    false    224    219    4720            �           2606    24620 (   Transaction Transaction_category_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE SET NULL;
 V   ALTER TABLE ONLY public."Transaction" DROP CONSTRAINT "Transaction_category_id_fkey";
       public               postgres    false    221    222    4726            �           2606    24615 $   Transaction Transaction_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"("oidcId") ON UPDATE CASCADE ON DELETE SET NULL;
 R   ALTER TABLE ONLY public."Transaction" DROP CONSTRAINT "Transaction_user_id_fkey";
       public               postgres    false    219    222    4720            �           2606    16479 !   UserDevice UserDevice_userId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."UserDevice"
    ADD CONSTRAINT "UserDevice_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"("oidcId") ON UPDATE CASCADE ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public."UserDevice" DROP CONSTRAINT "UserDevice_userId_fkey";
       public               postgres    false    220    4720    219                  x������ � �         x  x�-�M�[7��W��XP)J�t ��uB�T�ֱl�YR֑��.21��#���ݼ��Q`#*��{m�7�P���=���塏�����R�o@��`� ��(��������z�|JY,t�`v-@�z���M$�6���᷋?�Ș7��� 7�)}BA'v\5K=������Nz��!�:	�ZZ�@q=/�kwi嘮o��?�y��G����B��3hۓL���q��S[���hƝ[�xG�J���f�C�x��r��i��=bjF ��C��b�!(|��ao�W�^������ZƖ�T�����q�{�d��"X]��D�������3�q,�H����6��vT�[�г��>B���]?yʝ�0�T������1�T2,Q�YO7Ou�e`h�빨3TE��+y.����+`����AY�0�6�~���(����-�Js�5(yP[,�[x�����>ٲ�k�83��N���n�?���~��Z��L���.]��z�&V����9QCsv��;��9Au#n��![�o�5a�{ )m�'#��RX�Jt=�x������W��>��F�F5떥 �����ㇿ^�|IuK�!�Հ���s��E��^����������o)�� �r�      !      x������ � �             x������ � �         x  x���[O"K���_�(����o`� ��"����0( ��?��Ϙ~������z���^w��B�hK,[� e��7�l:xnh��ݲ�����q�z�B`�Go	ZYAI�\$&*nǀ`3
�1`H��.)���&�ʲ�ʽ,ÅY��7o��1,��+'�ug+��qEm(� BDO�H��T1 m@f����z?[��n�wQv����W���ņO��|w�e�{[�Ȩ�J8Rjˈ�A��$�E���2��U�T��j����O�*��k�(�n*��.���#�E��U�(�V1!�N'#�R��)֌8C�M{3��fT��iQ�)1��+C$I�!� %�	Z@]f��L9��kZ�)���vr�~n���cA��X�����e�%{!g�E.�JW�ӡ]��>bli�E��F/��$�H���ez��X�ӻ>B��*?C�5�g�q�n��/��Mz��6���
{�s����S�1� 0��T���2��sS3����P,f����zx�[m;�Ѹ#�<G���ge�VUK������r�}��b?k]=��m���QP�X�#��K����Vx`=��	�c����jT��}k�����`ӛ��!�� Mp"o� ��:�h�=��8�}��2��8�g��Q� ~D�u���&��y�Ԉ��1���4�$���(1�M�2k(L���4�H��zm��}r�o���m{^��r��qR��aܱ?	Om+]�"��D9��\�b�U.�&��'��R��;�f���0��ؐ�x)H�^��D=�`1�:�.j%������?���>A?��揫�1�o�t{�#�P���x���]Ĥ�EgK/� 댛�[))�R�F����ſU}Ԕ         j  x����n�@�ky��]i,��BL� ��"2�,O�BoZM��\͙�%g2�,_��E�� ��=92�@��`7� �.,�r��9���|~L��Zot�߸4��E��\��s�����|t�q�����Z#��+Oq��,���b�UYز	�v���_�n���6�՞�ب�ʡ��4Bx�N_��$Jq! (Y��A�*:��稽����X�J&[K	{P?*ZE�v&����7�i)�=�-}�9O�f�x��>%;�����E�y��"���ފS��<U֣��@�:�R^sz+JCwL��:լ�**{W�{���H���(i��� zKq~�,	��Hfϗn��ð <            x������ � �     